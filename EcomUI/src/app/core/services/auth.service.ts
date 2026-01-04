import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable, tap } from 'rxjs';
import { Router } from '@angular/router';

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    private http = inject(HttpClient);
    private router = inject(Router);
    private apiUrl = environment.apiUrl + '/Auth';

    // Signals to track user state (simple version for now)
    currentUser = signal<{ email: string } | null>(null); // We could decode token or fetch profile if needed

    register(data: any): Observable<any> {
        return this.http.post(`${this.apiUrl}/register`, data, { withCredentials: true }).pipe(
            tap(() => this.currentUser.set({ email: data.email })) // Optimistically set user or fetch profile
        );
    }

    login(data: any): Observable<any> {
        return this.http.post(`${this.apiUrl}/login`, data, { withCredentials: true }).pipe(
            tap(() => this.currentUser.set({ email: data.email }))
        );
    }

    getUser(): Observable<any> {
        return this.http.get(`${this.apiUrl}/me`, { withCredentials: true }).pipe(
            tap((user: any) => this.currentUser.set({ email: user.email }))
        );
    }

    logout(): void {
        this.http.post(`${this.apiUrl}/logout`, {}, { withCredentials: true }).subscribe({
            next: () => {
                this.currentUser.set(null);
                this.router.navigate(['/login']);
            },
            error: () => {
                // Even if API fails, clear local state
                this.currentUser.set(null);
                this.router.navigate(['/login']);
            }
        });
    }
}
