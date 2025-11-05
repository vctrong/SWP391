<%-- 
    Document   : denied
    Created on : Nov 1, 2025, 3:37:08 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>403 - Khu Vực Cấm | Sweetimal</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Bubblegum+Sans&family=Poppins:wght@400;600&display=swap" rel="stylesheet">

  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(180deg, #a5f3fc, #bae6fd, #cffafe);
      overflow: hidden;
      height: 100vh;
    }

    .error-code {
      font-family: 'Bubblegum Sans', cursive;
      font-size: 8rem;
      color: #0ea5e9;
      text-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
      animation: popIn 0.8s ease forwards;
    }

    @keyframes popIn {
      0% { transform: scale(0.2); opacity: 0; }
      80% { transform: scale(1.1); opacity: 1; }
      100% { transform: scale(1); }
    }

    .mascot {
      width: 180px;
      animation: wag 3s infinite ease-in-out;
      cursor: pointer;
    }

    @keyframes wag {
      0%, 100% { transform: rotate(0deg); }
      50% { transform: rotate(3deg); }
    }

    .mascot:hover {
      animation: nod 0.8s infinite ease-in-out;
    }

    @keyframes nod {
      0%, 100% { transform: rotate(0deg); }
      50% { transform: rotate(-5deg); }
    }

    .btn {
      background-color: #06b6d4;
      color: white;
      padding: 0.8rem 1.8rem;
      font-weight: 600;
      border-radius: 9999px;
      transition: all 0.3s ease;
      box-shadow: 0 4px 12px rgba(6, 182, 212, 0.3);
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      animation: pulse 1.8s infinite;
    }

    .btn:hover {
      background-color: #0891b2;
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(6, 182, 212, 0.4);
    }

    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.06); }
    }

    /* Particles */
    .particle {
      position: absolute;
      font-size: 1.2rem;
      opacity: 0.9;
      animation: fly 4s ease-in-out infinite;
      pointer-events: none;
    }

    @keyframes fly {
      0% {
        transform: translate(0, 0) scale(1);
        opacity: 1;
      }
      80% {
        transform: translate(var(--x), var(--y)) rotate(360deg) scale(1.2);
        opacity: 0.7;
      }
      100% {
        opacity: 0;
        transform: translate(var(--x), calc(var(--y) + 50px)) scale(0.5);
      }
    }

    .bg-decor {
      background-image: url('https://cdn-icons-png.flaticon.com/512/616/616408.png');
      background-repeat: repeat;
      background-size: 80px;
      opacity: 0.03;
      position: absolute;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      z-index: 0;
    }
  </style>
</head>

<body class="flex items-center justify-center text-center relative">

  <div class="bg-decor"></div>

  <div class="z-10 p-6 rounded-xl backdrop-blur-sm bg-white/60 shadow-lg max-w-lg mx-auto">
    <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" alt="Sweetimal Guardian" class="mascot mx-auto mb-4 drop-shadow-lg">
    <div class="error-code mb-2">403</div>
    <h1 class="text-2xl font-bold text-cyan-700 mb-2">🐾 Ối Chà! Khu Vực Cấm! 🦴</h1>
    <p class="text-gray-700 leading-relaxed mb-6">
      Oops! Có vẻ bạn vừa "lạc" vào kho đồ chơi bí mật của tụi tớ rồi.<br/>
      Khu vực này <strong>Boss Gác Cửa</strong> đang trông coi nghiêm ngặt đó nha! 😼<br/>
      Hãy quay về sảnh chính để chơi cùng tụi tớ nhé!
    </p>
    <a href="${pageContext.request.contextPath}/home" class="btn">
      🐾 Quay về Sảnh Chính Sweetimal
    </a>
  </div>

  <script>
    // Particle effects
    const icons = ["🐾", "🐟", "🦴", "⚽", "❤️"];
    for (let i = 0; i < 30; i++) {
      const particle = document.createElement("div");
      particle.className = "particle";
      particle.innerText = icons[Math.floor(Math.random() * icons.length)];
      document.body.appendChild(particle);
      const x = (Math.random() - 0.5) * window.innerWidth + "px";
      const y = (Math.random() - 0.5) * window.innerHeight + "px";
      particle.style.setProperty("--x", x);
      particle.style.setProperty("--y", y);
      particle.style.left = Math.random() * 100 + "%";
      particle.style.top = Math.random() * 100 + "%";
      particle.style.animationDelay = (Math.random() * 3) + "s";
    }
  </script>

</body>
</html>
