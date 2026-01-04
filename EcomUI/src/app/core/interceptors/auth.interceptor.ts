import { HttpInterceptorFn } from '@angular/common/http';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
    // Clone the request to include credentials (cookies)
    const authReq = req.clone({
        withCredentials: true
    });
    return next(authReq);
};
