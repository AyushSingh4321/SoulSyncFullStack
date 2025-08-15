import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soulsync_frontend/app/modules/auth/controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      // Logo and title
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'SoulSync',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() => Text(
                              controller.isLogin.value 
                                  ? 'Welcome back!' 
                                  : 'Create your account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      
                      // Form fields
                      Obx(() => Column(
                        children: [
                          // Username field (only for signup)
                          if (!controller.isLogin.value) ...[
                            TextField(
                              controller: controller.usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // Email field
                          TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Password field
                          TextField(
                            controller: controller.passwordController,
                            obscureText: controller.obscurePassword.value,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                          ),
                          
                          // OTP field (only for signup when OTP is sent)
                          if (!controller.isLogin.value && controller.showOtpField.value) ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: controller.otpController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'OTP',
                                prefixIcon: Icon(Icons.security),
                              ),
                            ),
                          ],
                        ],
                      )),
                      
                      const SizedBox(height: 32),
                      
                      // Action buttons
                      Obx(() => Column(
                        children: [
                          if (controller.isLogin.value) ...[
                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value 
                                    ? null 
                                    : controller.login,
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Login'),
                              ),
                            ),
                          ] else ...[
                            // Signup flow buttons
                            if (!controller.showOtpField.value) ...[
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value 
                                      ? null 
                                      : controller.sendOtp,
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text('Send OTP'),
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value 
                                      ? null 
                                      : controller.validateOtp,
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text('Verify & Sign Up'),
                                ),
                              ),
                            ],
                          ],
                        ],
                      )),
                      
                      const SizedBox(height: 20),
                      
                      // Toggle auth mode
                      Center(
                        child: TextButton(
                          onPressed: controller.toggleAuthMode,
                          child: Obx(() => Text(
                            controller.isLogin.value
                                ? "Don't have an account? Sign up"
                                : "Already have an account? Login",
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}