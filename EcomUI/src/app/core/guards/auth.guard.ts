import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = (route, state) => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.currentUser()) {
        return true;
    }

    // Optional: Try to restore session if not loaded?
    // For now, redirect to login
    return router.createUrlTree(['/login']);
};
