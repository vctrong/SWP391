package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Simple DTO for a news article parsed from RSS.
 */
public class NewsItem implements Serializable {
    private String source;       // vnexpress | petfinder | petcarevn
    private String title;
    private String link;
    private Date publishedAt;
    private String description;
    private String imageUrl;
    private String author;

    public NewsItem() {}

    public NewsItem(String source, String title, String link, Date publishedAt, String description, String imageUrl, String author) {
        this.source = source;
        this.title = title;
        this.link = link;
        this.publishedAt = publishedAt;
        this.description = description;
        this.imageUrl = imageUrl;
        this.author = author;
    }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public Date getPublishedAt() { return publishedAt; }
    public void setPublishedAt(Date publishedAt) { this.publishedAt = publishedAt; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
}
