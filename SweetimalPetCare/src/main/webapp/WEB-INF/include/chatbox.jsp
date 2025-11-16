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