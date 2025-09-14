<%-- 
    Document   : home
    Created on : Sep 15, 2025, 12:41:25 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Sweetimal PetCare</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-white text-gray-800">
        <!-- Navbar -->
        <%@include file="/WEB-INF/include/header.jsp" %>

        <!-- Hero Section -->
        <section class="relative bg-blue-100">
            <div class="container mx-auto flex flex-col md:flex-row items-center py-20 px-6">
                <div class="md:w-1/2">
                    <h2 class="text-4xl md:text-5xl font-bold mb-6 text-blue-800">
                        Caring for Your Pets with Love & Passion
                    </h2>
                    <p class="text-lg mb-6">
                        Discover premium services and products for your pets. From grooming to healthy meals, we have it all.
                    </p>
                    <a href="#services" class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Explore Services</a>
                </div>
                <div class="md:w-1/2 mt-10 md:mt-0">
                    <img src="https://cdn.pixabay.com/photo/2017/09/25/13/12/dog-2785074_1280.jpg" alt="Pet care" class="rounded-2xl shadow-lg">
                </div>
            </div>
        </section>


        <!-- About -->
        <section class="py-16 px-6 text-center">
            <h2 class="text-3xl font-bold mb-4">About Sweetimal PetCare</h2>
            <p class="max-w-2xl mx-auto text-gray-600">We provide top-notch pet grooming, veterinary checkups, and a wide variety of pet products to keep your furry friends happy and healthy.</p>
        </section>

        <!-- Services Preview -->
        <section id="services" class="py-16 bg-gray-50 px-6 text-center">
            <h2 class="text-3xl font-bold mb-8">Our Services</h2>
            <div class="grid md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" class="w-16 mx-auto mb-4" />
                    <h3 class="font-semibold text-lg">Pet Grooming</h3>
                    <p class="text-gray-500 text-sm">Professional grooming for all breeds.</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" class="w-16 mx-auto mb-4" />
                    <h3 class="font-semibold text-lg">Veterinary Care</h3>
                    <p class="text-gray-500 text-sm">Experienced vets to keep your pet healthy.</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" class="w-16 mx-auto mb-4" />
                    <h3 class="font-semibold text-lg">Pet Training</h3>
                    <p class="text-gray-500 text-sm">Obedience training for better behavior.</p>
                </div>
            </div>
            <a href="/services" class="inline-block mt-8 bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600">See More Services</a>
        </section>

        <!-- Shop Preview -->
        <section id="shop" class="py-16 px-6 text-center">
            <h2 class="text-3xl font-bold mb-8">Pet Shop</h2>
            <div class="grid md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://images.unsplash.com/photo-1558788353-f76d92427f16?auto=format&fit=crop&w=400&q=80" class="w-full h-40 object-cover rounded-lg mb-4" />
                    <h3 class="font-semibold">Dog Food</h3>
                    <p class="text-gray-500 text-sm">$25.00</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://images.unsplash.com/photo-1598133894005-449d6e5c7fbb?auto=format&fit=crop&w=400&q=80" class="w-full h-40 object-cover rounded-lg mb-4" />
                    <h3 class="font-semibold">Cat Toy</h3>
                    <p class="text-gray-500 text-sm">$10.00</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://images.unsplash.com/photo-1619983081654-7fa34b5d2a5a?auto=format&fit=crop&w=400&q=80" class="w-full h-40 object-cover rounded-lg mb-4" />
                    <h3 class="font-semibold">Pet Bed</h3>
                    <p class="text-gray-500 text-sm">$45.00</p>
                </div>
            </div>
            <a href="/shop" class="inline-block mt-8 bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600">Go to Shop</a>
        </section>

        <!-- Consultation Form -->
        <section id="contact" class="py-16 bg-gray-100 px-6 text-center">
            <h2 class="text-3xl font-bold mb-6">Request a Free Consultation</h2>
            <form class="max-w-xl mx-auto space-y-4">
                <input type="text" placeholder="Your Name" class="w-full border rounded-lg px-4 py-3" />
                <input type="email" placeholder="Your Email" class="w-full border rounded-lg px-4 py-3" />
                <select class="w-full border rounded-lg px-4 py-3">
                    <option>Select Service/Product</option>
                    <option>Pet Grooming</option>
                    <option>Veterinary Care</option>
                    <option>Pet Training</option>
                    <option>Shop Inquiry</option>
                </select>
                <textarea placeholder="Your Message" class="w-full border rounded-lg px-4 py-3"></textarea>
                <button type="submit" class="bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600">Submit</button>
            </form>
        </section>

        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>



