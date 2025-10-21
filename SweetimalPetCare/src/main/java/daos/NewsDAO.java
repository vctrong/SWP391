package daos;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import model.NewsItem;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * DAO that reads external RSS feeds and returns unified NewsItem objects.
 * No persistence; purely fetch-and-parse.
 */
public class NewsDAO {

    public enum Source {
        PETCAREVN("petcarevn", "https://www.petcare.vn/feed/");

        public final String key;
        public final String rssUrl;
        Source(String key, String rssUrl) { this.key = key; this.rssUrl = rssUrl; }

        public static Source fromKey(String k) {
            if (k == null) return null;
            for (Source s : values()) if (s.key.equalsIgnoreCase(k)) return s;
            return null;
        }
    }

    public List<NewsItem> getNews(String sourceKey, String query, int limit) {
        List<NewsItem> all = new ArrayList<>();
        List<Source> sources;
        // Restrict to PetCareVN regardless of input
        sources = new ArrayList<Source>();
        sources.add(Source.PETCAREVN);
        int effectiveLimit = (limit > 0 ? limit : 20);
        for (Source s : sources) {
            try {
                // Fetch multiple pages until reaching effectiveLimit
                List<NewsItem> items = fetchRssPaged(s, effectiveLimit);
                all.addAll(items);
            } catch (Exception ex) {
                // swallow individual source errors, continue others
            }
        }
        // sort desc by date
        java.util.Collections.sort(all, new java.util.Comparator<NewsItem>() {
            @Override
            public int compare(NewsItem a, NewsItem b) {
                Date da = a.getPublishedAt();
                Date db = b.getPublishedAt();
                long la = da == null ? 0 : da.getTime();
                long lb = db == null ? 0 : db.getTime();
                if (lb == la) return 0;
                return lb > la ? 1 : -1;
            }
        });
        if (effectiveLimit > 0 && all.size() > effectiveLimit) return new ArrayList<NewsItem>(all.subList(0, effectiveLimit));
        return all;
    }

    // Fetch multiple RSS pages: /feed/ and /feed/?paged=2,3,... until limit or maxPages reached
    private List<NewsItem> fetchRssPaged(Source src, int limit) throws Exception {
        List<NewsItem> out = new ArrayList<NewsItem>();
        int page = 1;
        int maxPages = 10; // safety cap
        while (out.size() < limit && page <= maxPages) {
            String urlStr;
            if (page == 1) {
                urlStr = src.rssUrl;
            } else {
                urlStr = src.rssUrl + (src.rssUrl.indexOf('?') >= 0 ? "&" : "?") + "paged=" + page;
            }
            List<NewsItem> pageItems = fetchRssWithUrl(src, urlStr);
            if (pageItems == null || pageItems.isEmpty()) break;
            out.addAll(pageItems);
            page++;
        }
        return out;
    }

    // Reuse parser with a specific URL (page)
    private List<NewsItem> fetchRssWithUrl(Source src, String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setConnectTimeout(8000);
        conn.setReadTimeout(8000);
        conn.setRequestProperty("User-Agent", "SweetimalPetCareBot/1.0");
        try (InputStream in = new BufferedInputStream(conn.getInputStream())) {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
            dbf.setNamespaceAware(false);
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(in);
            Element root = doc.getDocumentElement();
            NodeList channelList = root.getElementsByTagName("channel");
            if (channelList.getLength() > 0) {
                Element channel = (Element) channelList.item(0);
                return parseChannelItems(src, channel.getElementsByTagName("item"));
            } else {
                NodeList entries = root.getElementsByTagName("entry");
                return parseAtomEntries(src, entries);
            }
        } finally {
            conn.disconnect();
        }
    }

    private List<NewsItem> parseChannelItems(Source src, NodeList items) {
        List<NewsItem> list = new ArrayList<>();
        for (int i = 0; i < items.getLength(); i++) {
            Node n = items.item(i);
            if (n.getNodeType() != Node.ELEMENT_NODE) continue;
            Element e = (Element) n;
            String title = text(e, "title");
            String link = text(e, "link");
            String desc = cdataOrText(e, "description");
            String contentEncoded = text(e, "content:encoded");
            String author = text(e, "author");
            if (author == null) author = text(e, "dc:creator");
            Date pub = parseDate(text(e, "pubDate"));
            // Try to extract image from media tags / enclosure / content:encoded
            String img = extractImage(e, contentEncoded != null ? contentEncoded : desc);
            if ((img == null || img.length() == 0) && link != null && link.startsWith("http")) {
                // Fallback: fetch og:image from article page
                try {
                    String og = fetchOgImage(link);
                    if (og != null && og.length() > 0) img = og;
                } catch (Exception ignored) {}
            }
            NewsItem item = new NewsItem(src.key, title, link, pub, clean(desc), img, author);
            list.add(item);
        }
        return list;
    }

    private List<NewsItem> parseAtomEntries(Source src, NodeList entries) {
        List<NewsItem> list = new ArrayList<>();
        for (int i = 0; i < entries.getLength(); i++) {
            Node n = entries.item(i);
            if (n.getNodeType() != Node.ELEMENT_NODE) continue;
            Element e = (Element) n;
            String title = childText(e, "title");
            String link = attrOfChild(e, "link", "href");
            String summary = childText(e, "summary");
            if (summary == null) summary = childText(e, "content");
            String author = childTextPath(e, new String[]{"author","name"});
            Date pub = parseDate(childText(e, "updated"));
            // Try to capture image from summary/content
            String img = extractFirstImg(summary);
            list.add(new NewsItem(src.key, title, link, pub, clean(summary), img, author));
        }
        return list;
    }

    private String text(Element parent, String tag) {
        NodeList nl = parent.getElementsByTagName(tag);
        if (nl.getLength() == 0) return null;
        return nl.item(0).getTextContent();
    }

    private String cdataOrText(Element parent, String tag) {
        NodeList nl = parent.getElementsByTagName(tag);
        if (nl.getLength() == 0) return null;
        Node n = nl.item(0);
        return n.getTextContent();
    }

    private String childText(Element parent, String tag) {
        NodeList nl = parent.getElementsByTagName(tag);
        if (nl.getLength() == 0) return null;
        return nl.item(0).getTextContent();
    }

    private String childTextPath(Element parent, String[] path) {
        Element cur = parent;
        for (String p : path) {
            NodeList nl = cur.getElementsByTagName(p);
            if (nl.getLength() == 0) return null;
            Node n = nl.item(0);
            if (n.getNodeType() != Node.ELEMENT_NODE) return null;
            cur = (Element) n;
        }
        return cur.getTextContent();
    }

    private String attrOfChild(Element parent, String tag, String attr) {
        NodeList nl = parent.getElementsByTagName(tag);
        if (nl.getLength() == 0) return null;
        Node n = nl.item(0);
        if (n.getNodeType() != Node.ELEMENT_NODE) return null;
        Element e = (Element) n;
        return e.hasAttribute(attr) ? e.getAttribute(attr) : null;
    }

    private Date parseDate(String s) {
        if (s == null) return null;
        String[] fmts = new String[] {
            "EEE, dd MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ssXXX"
        };
        for (String f : fmts) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(f, Locale.ENGLISH);
                sdf.setLenient(true);
                sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
                return sdf.parse(s);
            } catch (ParseException ignored) {}
        }
        return new Date();
    }

    private String extractImage(Element item, String htmlCandidate) {
        // Try media:content
        NodeList medias = item.getElementsByTagName("media:content");
        if (medias.getLength() > 0) {
            Node mn = medias.item(0);
            if (mn.getNodeType() == Node.ELEMENT_NODE) {
                Element me = (Element) mn;
                if (me.hasAttribute("url")) return me.getAttribute("url");
            }
        }
        // Try enclosure
        NodeList enclosures = item.getElementsByTagName("enclosure");
        if (enclosures.getLength() > 0) {
            Node en = enclosures.item(0);
            if (en.getNodeType() == Node.ELEMENT_NODE) {
                Element ee = (Element) en;
                if (ee.hasAttribute("url")) return ee.getAttribute("url");
            }
        }
        // Try first img from provided html (content:encoded or description)
        String cand = extractFirstImg(htmlCandidate);
        if (cand != null) return cand;
        return null;
    }

    private String extractFirstImg(String html) {
        if (html == null) return null;
        String lower = html.toLowerCase();
        int idx = lower.indexOf("<img");
        if (idx == -1) return null;
        int srcIdx = lower.indexOf("src", idx);
        if (srcIdx == -1) return null;
        int quoteIdx = lower.indexOf('"', srcIdx);
        int quoteIdx2 = lower.indexOf('"', quoteIdx + 1);
        if (quoteIdx != -1 && quoteIdx2 != -1) return html.substring(quoteIdx + 1, quoteIdx2);
        int apos1 = lower.indexOf('\'', srcIdx);
        int apos2 = lower.indexOf('\'', apos1 + 1);
        if (apos1 != -1 && apos2 != -1) return html.substring(apos1 + 1, apos2);
        return null;
    }

    private String fetchOgImage(String pageUrl) throws IOException {
        HttpURLConnection c = (HttpURLConnection) new URL(pageUrl).openConnection();
        c.setConnectTimeout(8000);
        c.setReadTimeout(8000);
        c.setRequestProperty("User-Agent", "SweetimalPetCareBot/1.0");
        try {
            InputStream in = new BufferedInputStream(c.getInputStream());
            byte[] buf = readAllBytesLimited(in, 1024 * 1024); // limit 1MB
            String html = new String(buf, "UTF-8");
            String l = html.toLowerCase();
            String key = "property=\"og:image\"";
            int p = l.indexOf(key);
            if (p == -1) return null;
            int tagStart = l.lastIndexOf("<meta", p);
            int tagEnd = l.indexOf('>', p);
            if (tagStart == -1 || tagEnd == -1) return null;
            String tag = html.substring(tagStart, tagEnd + 1);
            String cl = tag.toLowerCase();
            int ci = cl.indexOf("content=");
            if (ci == -1) return null;
            int q1 = tag.indexOf('"', ci);
            int q2 = tag.indexOf('"', q1 + 1);
            if (q1 != -1 && q2 != -1) return tag.substring(q1 + 1, q2);
            int a1 = tag.indexOf('\'', ci);
            int a2 = tag.indexOf('\'', a1 + 1);
            if (a1 != -1 && a2 != -1) return tag.substring(a1 + 1, a2);
            return null;
        } finally {
            c.disconnect();
        }
    }

    private byte[] readAllBytesLimited(InputStream in, int max) throws IOException {
        byte[] buf = new byte[max];
        int pos = 0;
        int r;
        byte[] chunk = new byte[8192];
        while ((r = in.read(chunk)) != -1) {
            int toCopy = Math.min(r, max - pos);
            System.arraycopy(chunk, 0, buf, pos, toCopy);
            pos += toCopy;
            if (pos >= max) break;
        }
        byte[] out = new byte[pos];
        System.arraycopy(buf, 0, out, 0, pos);
        return out;
    }

    private String clean(String html) {
        if (html == null) return null;
        // naive strip tags
        return html.replaceAll("<[^>]*>", "").trim();
    }
}
