<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String __uri = request.getRequestURI();
    boolean __hideChat = false;
    if (__uri != null) {
        String __l = __uri.toLowerCase();
        __hideChat = __l.contains("/login") || __l.contains("login.jsp") || __l.contains("/signup") || __l.contains("signup.jsp");
    }
%>
<% if (!__hideChat) { %>
<!-- Tailwind CDN (ensure included once globally; harmless if repeated) -->
<script src="https://cdn.tailwindcss.com"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/chatbox.css" />

<!-- Floating Chat Icon (use logo) -->
<button id="vet-chat-toggle"
        class="fixed bottom-5 right-5 z-50 rounded-full shadow-xl transform transition-transform duration-200 hover:scale-110 focus:outline-none focus:ring-4 focus:ring-blue-300 overflow-hidden border border-blue-200 bg-white"
        style="width:50px;height:50px;">
    <img src="<%= request.getContextPath() %>/assets/img/logo.jpg" alt="Sweetimal" class="w-full h-full object-cover" />
    <span class="sr-only">Open Vet Chat</span>
 </button>

<!-- Chat Window -->
<div id="vet-chat-window" class="fixed bottom-20 right-5 z-50 w-80 h-96 bg-white rounded-xl shadow-xl border border-gray-200 hidden flex flex-col overflow-hidden">
    <div class="flex items-center justify-between px-4 py-2 bg-blue-600 text-white">
        <h3 class="font-semibold">Sweetimal Vet Chat</h3>
        <div class="space-x-2">
            <button id="vet-chat-minimize" class="px-2 py-1 bg-blue-500 hover:bg-blue-400 rounded text-sm">↺</button>
            <button id="vet-chat-close" class="px-2 py-1 bg-red-500 hover:bg-red-400 rounded text-sm">×</button>
        </div>
    </div>
    <div id="vet-chat-body" class="flex-1 min-h-0 p-3 overflow-y-scroll bg-gray-50">
        <div class="bg-gray-100 p-2 rounded-lg my-2 text-sm">
            Xin chào 🐾! Tôi là bác sĩ thú y Sweetimal. Bạn muốn được tư vấn về vấn đề nào?
        </div>
        <div id="vet-options" class="mt-2 space-y-2">
            <button data-action="emergency" class="vet-option-btn bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-full w-full"> Dấu hiệu cấp cứu</button>
            <button data-action="nutrition" class="vet-option-btn bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-full w-full"> Tư vấn dinh dưỡng</button>
            <button data-action="behavior" class="vet-option-btn bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-full w-full">Hành vi và huấn luyện</button>
            <button data-action="reproduction" class="vet-option-btn bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-full w-full">Sinh sản và triệt sản</button>
            <button data-action="care" class="vet-option-btn bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-full w-full">Chăm sóc và vệ sinh</button>
        </div>
    </div>
    
</div>

<script>
    window.VET_CHATBOT_ENDPOINT = '<%= request.getContextPath() %>/chatbot';
</script>
<script>
(function(){
  const toggle = document.getElementById('vet-chat-toggle');
  const win = document.getElementById('vet-chat-window');
  const closeBtn = document.getElementById('vet-chat-close');
  const minimizeBtn = document.getElementById('vet-chat-minimize');
  const body = document.getElementById('vet-chat-body');
  const endpoint = window.VET_CHATBOT_ENDPOINT || '/chatbot';
  function getOptionsContainer(){ return document.getElementById('vet-options'); }
  let chosen = false;
  let pendingDeepBase = null;

  const deepFallback = {
    emergency_bleeding: 'Chảy máu nhiều:\n1) Dùng gạc/khăn sạch ấn trực tiếp 5–10 phút.\n2) Băng cố định, nâng cao vị trí nếu có thể.\n3) Không rút dị vật cắm sâu.\n4) Đưa đi cấp cứu ngay.',
    emergency_breath: 'Khó thở/Ngạt:\n1) Giữ cổ thẳng, nới vòng cổ.\n2) Tránh stress, hạn chế vận động.\n3) Không móc dị vật sâu.\n4) Đi cấp cứu ngay.',
    emergency_seizure: 'Co giật/Bất tỉnh:\n1) Dọn vật sắc nhọn, đảm bảo an toàn.\n2) Không cho đồ vào miệng.\n3) Ghi lại thời gian cơn.\n4) Liên hệ bác sĩ sớm.',
    nutrition_puppy: 'Chó/Mèo con:\n• 3–4 bữa/ngày theo cân nặng & tuổi.\n• Công thức puppy/kitten giàu DHA.\n• Bổ sung theo chỉ định.\n• Theo dõi tăng trưởng.',
    nutrition_overweight: 'Thừa cân/Béo phì:\n• Thức ăn kiểm soát cân.\n• Vận động 20–30 phút/ngày.\n• Hạn chế snack.\n• Mục tiêu giảm 1–2%/tuần.',
    nutrition_allergy: 'Dị ứng/Đường ruột:\n• Thuỷ phân/novel protein.\n• Phác đồ loại trừ 6–8 tuần.\n• Theo dõi da & tiêu hoá.\n• Tái khám điều chỉnh.',
    behavior_bark_destroy: 'Giảm sủa/cắn phá:\n• Tăng vận động và kích thích trí tuệ (đồ chơi nhồi thức ăn, puzzle).\n• Bỏ qua hành vi xấu, thưởng ngay khi im lặng/bình tĩnh.\n• Dạy lệnh "Im"/"Để đó" kết hợp clicker/đồ ăn thưởng.\n• Tránh phạt nặng tay, tìm nguyên nhân (chán, lo âu, thiếu vận động).',
    behavior_introduce_pets: 'Làm quen thú cưng mới–cũ:\n• Cách ly ban đầu, trao đổi mùi qua khăn/đồ vật.\n• Gặp mặt có kiểm soát, ngắn và tích cực, thưởng khi bình tĩnh.\n• Tăng dần thời gian, giám sát chặt chẽ.\n• Không ép buộc, luôn có lối thoát và nơi trú an toàn.',
    behavior_basic_commands: 'Lệnh cơ bản nên dạy:\n• Tên gọi (nhìn bạn), "Ngồi", "Nằm", "Lại đây", "Đợi".\n• Học qua phần thưởng nhỏ, buổi ngắn 3–5 phút, nhiều lần/ngày.\n• Tăng khó dần, luyện nhiều bối cảnh.\n• Nhất quán, tích cực, không trừng phạt.',
    reproduction_neuter_temperament: 'Triệt sản & tính cách:\n• Không làm đổi tính cách tích cực nếu huấn luyện đúng.\n• Có thể giảm hành vi liên quan hormone (đánh dấu, bỏ nhà).\n• Giúp ổn định nội tiết, giảm stress do động dục.',
    reproduction_breed_before_neuter: 'Có nên sinh sản 1 lứa trước khi triệt sản?\n• Không bắt buộc và không có lợi ích sức khoẻ rõ ràng.\n• Triệt sản đúng thời điểm giúp giảm nguy cơ bệnh sinh sản.\n• Quyết định nên dựa trên sức khoẻ và kế hoạch gia đình.',
    reproduction_when_neuter: 'Khi nào nên triệt sản?\n• Chó: thường 6–12 tháng (tuỳ giống/kích thước, hỏi bác sĩ).\n+    • Mèo: khoảng 5–6 tháng, trước dậy thì.\n• Cân nhắc cá thể: sức khoẻ, hành vi, môi trường.',
    care_bathing_frequency: 'Tắm bao lâu 1 lần?\n• Chó: 2–4 tuần/lần tuỳ giống, da, hoạt động.\n• Mèo: thường tự làm sạch; chỉ tắm khi bẩn/da dầu.\n• Dùng sữa tắm thú y phù hợp da lông, sấy khô kỹ.',
    care_human_shampoo: 'Dùng dầu gội người?\n• Không nên: độ pH da khác, dễ kích ứng/khô da.\n• Nên dùng sản phẩm dành cho thú cưng, theo tư vấn bác sĩ.',
    care_clean_ears_teeth: 'Vệ sinh tai & răng:\n• Tai: dung dịch chuyên dụng, nhỏ vào tai, massage, lau nhẹ phần ngoài. Không dùng tăm bông sâu.\n• Răng: chải 3–4 lần/tuần bằng bàn chải & kem đánh răng cho thú cưng.\n• Kết hợp đồ nhai hỗ trợ chăm sóc răng miệng.'
  };

  const deepOptions = {
    emergency: [
      { action: 'emergency_bleeding', label: 'Chảy máu nhiều' },
      { action: 'emergency_breath', label: 'Khó thở/Ngạt' },
      { action: 'emergency_seizure', label: 'Co giật/Bất tỉnh' }
    ],
    nutrition: [
      { action: 'nutrition_puppy', label: 'Chó con/Mèo con' },
      { action: 'nutrition_overweight', label: 'Thừa cân/Béo phì' },
      { action: 'nutrition_allergy', label: 'Dị ứng/Đường ruột' }
    ],
    behavior: [
      { action: 'behavior_bark_destroy', label: 'Làm sao để chó ngừng sủa nhiều hoặc cắn phá đồ?' },
      { action: 'behavior_introduce_pets', label: 'Cách làm quen giữa hai thú cưng mới và cũ?' },
      { action: 'behavior_basic_commands', label: 'Có cần dạy lệnh cơ bản cho chó không?' }
    ],
    reproduction: [
      { action: 'reproduction_neuter_temperament', label: 'Triệt sản có ảnh hưởng đến tính cách không?' },
      { action: 'reproduction_breed_before_neuter', label: 'Có nên cho thú cưng sinh sản một lứa trước khi triệt sản không?' },
      { action: 'reproduction_when_neuter', label: 'Khi nào nên triệt sản cho chó/mèo?' }
    ],
    care: [
      { action: 'care_bathing_frequency', label: 'Bao lâu nên tắm cho chó/mèo một lần?' },
      { action: 'care_human_shampoo', label: 'Có nên dùng dầu gội của người để tắm cho thú cưng không?' },
      { action: 'care_clean_ears_teeth', label: 'Cách vệ sinh tai, răng miệng cho thú cưng thế nào?' }
    ]
  };

   const mainOptions = [
     { action: 'emergency', label: 'Dấu hiệu cấp cứu' },
     { action: 'nutrition', label: 'Tư vấn dinh dưỡng' },
     { action: 'behavior', label: 'Hành vi và huấn luyện' },
     { action: 'reproduction', label: 'Sinh sản và triệt sản' },
     { action: 'care', label: 'Chăm sóc và vệ sinh' }
   ];

  function renderMainOptions(){
    let oc = getOptionsContainer();
    if (oc) { try { oc.parentNode.removeChild(oc); } catch(e){} }
    oc = document.createElement('div');
    oc.id = 'vet-options';
    oc.className = 'mt-3 space-y-2';
    mainOptions.forEach(function(opt){
      const btn = document.createElement('button');
      btn.className = 'vet-option-btn bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-full w-full';
      btn.setAttribute('data-action', opt.action);
      btn.textContent = opt.label;
      oc.appendChild(btn);
    });
    body.appendChild(oc);
    body.scrollTop = body.scrollHeight;
  }

  function renderBackButton(){
    const wrap = document.createElement('div');
    wrap.className = 'mt-2 vet-back-wrap';
    const btn = document.createElement('button');
    btn.className = 'vet-option-btn bg-gray-200 hover:bg-gray-300 text-gray-800 font-semibold py-2 px-4 rounded-full w-full';
    btn.setAttribute('data-action', 'back_main');
    btn.textContent = '⟵ Quay lại chọn chủ đề khác';
    wrap.appendChild(btn);
    const link = document.createElement('a');
    link.href = 'https://gemini.google.com/app?hl=vi';
    link.className = 'block text-center text-blue-600 hover:text-blue-700 underline text-sm mt-2';
    link.textContent = 'Chat chuyên sâu với bác sĩ AI';
    link.target = '_blank';
    link.rel = 'noopener noreferrer';
    wrap.appendChild(link);
    body.appendChild(wrap);
    body.scrollTop = body.scrollHeight;
    const link1 = document.createElement('a');
    link1.href = 'https://zalo.me/pc';
    link1.className = 'block text-center text-blue-600 hover:text-blue-700 underline text-sm mt-1';
    link1.textContent = 'Nói chuyện trực tiếp với bác sĩ Sweetimal';
    link1.target = '_blank';
    link1.rel = 'noopener noreferrer';
    wrap.appendChild(link1);
    body.appendChild(wrap);
    body.scrollTop = body.scrollHeight;
  }

  function clearDeepBlocks(){
    Array.from(body.querySelectorAll('.vet-sub-options, .vet-back-wrap')).forEach(function(el){
      try { el.parentNode.removeChild(el); } catch(e){}
    });
  }

  function openWin(){ win.classList.remove('hidden'); }
  function closeWin(){ win.classList.add('hidden'); }

  if(toggle){ toggle.addEventListener('click', openWin); }
  if(closeBtn){ closeBtn.addEventListener('click', closeWin); }
  if(minimizeBtn){
    minimizeBtn.addEventListener('click', function(){
      chosen = false;
      pendingDeepBase = null;
      while (body.firstChild) { body.removeChild(body.firstChild); }
      const greet = document.createElement('div');
      greet.className = 'bg-gray-100 p-2 rounded-lg my-2 text-sm';
      greet.textContent = 'Xin chào 🐾! Tôi là bác sĩ thú y Sweetimal. Bạn muốn được tư vấn về vấn đề nào?';
      body.appendChild(greet);
      renderMainOptions();
      if (win && win.classList) { win.classList.remove('hidden'); }
    });
  }

  function appendUserChoice(text){
    const div = document.createElement('div');
    div.className = 'text-right my-2';
    div.innerHTML = '<span class="inline-block bg-blue-500 text-white text-sm px-3 py-2 rounded-lg">'+escapeHtml(text)+'</span>';
    body.appendChild(div);
    body.scrollTop = body.scrollHeight;
  }

  function appendBotMessage(text){
    const div = document.createElement('div');
    div.className = 'my-2';
    const bubble = document.createElement('div');
    bubble.className = 'bg-gray-100 p-2 rounded-lg text-sm whitespace-pre-line';
    bubble.textContent = text || '';
    div.appendChild(bubble);
    body.appendChild(div);
    body.scrollTop = body.scrollHeight;
  }

  function escapeHtml(s){
    return (s||'').replace(/[&<>\"']/g, function(c){
      return {'&':'&amp;','<':'&lt;','>':'&gt;','\"':'&quot;','\'':'&#39;'}[c];
    });
  }

  function sendAction(action, label){
    appendUserChoice(label);
    let optionsContainer = getOptionsContainer();
    if (optionsContainer && !chosen) {
      chosen = true;
      if (optionsContainer.parentNode) optionsContainer.parentNode.removeChild(optionsContainer);
      const base = (action||'').split('_')[0];
      pendingDeepBase = base;
    }
    fetch(endpoint, {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
      body: 'action='+encodeURIComponent(action)
    }).then(r => r.json())
      .then(data => {
        let msg = (data && data.message) ? data.message : 'Xin lỗi, đã có lỗi xảy ra.';
        const defaultGreeting = 'Xin chào 🐾! Tôi là bác sĩ thú y Sweetimal. Bạn muốn được tư vấn về vấn đề nào?';
        if ((action||'').indexOf('_') !== -1 && (msg||'').trim() === defaultGreeting) {
          if (deepFallback[action]) msg = deepFallback[action];
        }
        appendBotMessage(msg);

        if (pendingDeepBase && (action||'').indexOf('_') === -1) {
          const sub = deepOptions[pendingDeepBase];
          if (sub && sub.length) {
            const subWrap = document.createElement('div');
            subWrap.className = 'mt-3 space-y-2 vet-sub-options';
            sub.forEach(function(opt){
              const btn = document.createElement('button');
              btn.className = 'vet-option-btn bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-full w-full';
              btn.setAttribute('data-action', opt.action);
              btn.textContent = opt.label;
              subWrap.appendChild(btn);
            });
            body.appendChild(subWrap);
            renderBackButton();
            body.scrollTop = body.scrollHeight;
          }
          pendingDeepBase = null;
        }

        if ((action||'').indexOf('_') !== -1) {
          clearDeepBlocks();
          renderBackButton();
          body.scrollTop = body.scrollHeight;
        }
      })
      .catch(() => appendBotMessage('Xin lỗi, đã có lỗi kết nối.'));
  }

  function onOptionClick(e){
    var target = e.target.closest('.vet-option-btn');
    if(!target) return;
    var action = target.getAttribute('data-action');
    var label = target.textContent.trim();
    if(action === 'back_main'){
      chosen = false;
      pendingDeepBase = null;
      clearDeepBlocks();
      renderMainOptions();
      return;
    }
    if(action){ sendAction(action, label); }
  }

  if(body){ body.addEventListener('click', onOptionClick); }
})();
</script>
<% } %>