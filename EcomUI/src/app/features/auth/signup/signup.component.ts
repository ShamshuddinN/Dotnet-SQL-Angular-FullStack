import { Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  template: `
    <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-2xl w-full space-y-8 bg-white p-8 rounded-xl shadow-lg">
        <div>
          <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Create your account
          </h2>
          <p class="mt-2 text-center text-sm text-gray-600">
            Already have an account?
            <a routerLink="/login" class="font-medium text-indigo-600 hover:text-indigo-500">
              Sign in
            </a>
          </p>
        </div>
        <form class="mt-8 space-y-6" [formGroup]="signupForm" (ngSubmit)="onSubmit()">
          
          <div *ngIf="errorMessage()" class="rounded-md bg-red-50 p-4 border border-red-200">
            <div class="flex">
              <div class="ml-3">
                <h3 class="text-sm font-medium text-red-800">{{ errorMessage() }}</h3>
              </div>
            </div>
          </div>

          <div class="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
            
            <!-- Full Name -->
            <div class="sm:col-span-6">
              <label for="fullName" class="block text-sm font-medium text-gray-700">Full Name</label>
              <div class="mt-1">
                <input type="text" formControlName="fullName" id="fullName" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border" required>
              </div>
            </div>

            <!-- Email -->
            <div class="sm:col-span-6">
              <label for="email" class="block text-sm font-medium text-gray-700">Email address</label>
              <div class="mt-1">
                <input type="email" formControlName="email" id="email" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border" required>
              </div>
            </div>

            <!-- Password -->
            <div class="sm:col-span-6">
              <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
              <div class="mt-1">
                <input type="password" formControlName="password" id="password" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border" required>
              </div>
              <p class="mt-1 text-xs text-gray-500">Must be at least 6 characters.</p>
            </div>

            <!-- Date of Birth -->
            <div class="sm:col-span-3">
              <label for="dateOfBirth" class="block text-sm font-medium text-gray-700">Date of Birth</label>
              <div class="mt-1">
                <input type="date" formControlName="dateOfBirth" id="dateOfBirth" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border" required>
              </div>
            </div>

            <!-- Gender -->
            <div class="sm:col-span-3">
               <label for="gender" class="block text-sm font-medium text-gray-700">Gender</label>
               <div class="mt-1">
                 <select id="gender" formControlName="gender" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
                   <option value="">Select</option>
                   <option value="Male">Male</option>
                   <option value="Female">Female</option>
                   <option value="Other">Other</option>
                 </select>
               </div>
            </div>

             <!-- Phone -->
             <div class="sm:col-span-6">
                <label for="phoneNumber" class="block text-sm font-medium text-gray-700">Phone Number</label>
                <div class="mt-1">
                  <input type="tel" formControlName="phoneNumber" id="phoneNumber" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
                </div>
              </div>

            <!-- Address 1 -->
            <div class="sm:col-span-6">
              <label for="addressLine1" class="block text-sm font-medium text-gray-700">Address Line 1</label>
              <div class="mt-1">
                <input type="text" formControlName="addressLine1" id="addressLine1" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
              </div>
            </div>

             <!-- Address 2 -->
             <div class="sm:col-span-6">
                <label for="addressLine2" class="block text-sm font-medium text-gray-700">Address Line 2 (Optional)</label>
                <div class="mt-1">
                  <input type="text" formControlName="addressLine2" id="addressLine2" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
                </div>
              </div>

            <!-- City -->
            <div class="sm:col-span-2">
              <label for="city" class="block text-sm font-medium text-gray-700">City</label>
              <div class="mt-1">
                <input type="text" formControlName="city" id="city" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
              </div>
            </div>

            <!-- State -->
            <div class="sm:col-span-2">
              <label for="state" class="block text-sm font-medium text-gray-700">State / Province</label>
              <div class="mt-1">
                <input type="text" formControlName="state" id="state" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
              </div>
            </div>

            <!-- Postal Code -->
            <div class="sm:col-span-2">
              <label for="postalCode" class="block text-sm font-medium text-gray-700">Postal Code</label>
              <div class="mt-1">
                <input type="text" formControlName="postalCode" id="postalCode" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
              </div>
            </div>
             <!-- Country -->
             <div class="sm:col-span-6">
                <label for="country" class="block text-sm font-medium text-gray-700">Country</label>
                <div class="mt-1">
                  <input type="text" formControlName="country" id="country" class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md p-2 border">
                </div>
              </div>

          </div>

          <div class="pt-5">
            <div class="flex justify-end">
              <button type="submit" [disabled]="signupForm.invalid || isLoading()" 
                class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:bg-indigo-400">
                {{ isLoading() ? 'Creating account...' : 'Sign up' }}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  `
})
export class SignupComponent {
  private fb = inject(FormBuilder);
  private authService = inject(AuthService);
  private router = inject(Router);

  signupForm = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(6)]],
    fullName: ['', Validators.required],
    dateOfBirth: ['', Validators.required],
    gender: [''],
    phoneNumber: [''],
    addressLine1: [''],
    addressLine2: [''],
    city: [''],
    state: [''],
    postalCode: [''],
    country: ['']
  });

  isLoading = signal(false);
  errorMessage = signal<string | null>(null);

  onSubmit() {
    if (this.signupForm.valid) {
      this.isLoading.set(true);
      this.errorMessage.set(null);
      console.log('Sending Signup payload:', this.signupForm.value);
      this.authService.register(this.signupForm.value).subscribe({
        next: () => {
          console.log('Signup Successful');
          this.isLoading.set(false);
          this.router.navigate(['/']); // Redirect to home (which is protected or specific page)
        },
        error: (err: any) => {
          console.error('Signup Failed:', err);
          this.isLoading.set(false);
          let msg = err.error?.Message || 'Registration failed. Please try again.';
          if (err.error?.errors) {
            msg += ' ' + JSON.stringify(err.error.errors);
          }
          this.errorMessage.set(msg);
        }
      });
    } else {
      // Mark all as touched to show errors
      this.signupForm.markAllAsTouched();
    }
  }
}
