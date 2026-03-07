import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable, retry, throwError, timer } from 'rxjs';
import { catchError } from 'rxjs/operators';

export interface Category {
  categoryId: number;
  categoryName: string;
  description?: string;
  parentCategoryId?: number;
  imageUrl?: string;
  isActive?: boolean;
  sortOrder?: number;
  createdAt?: Date;
  updatedAt?: Date;
}

@Injectable({
    providedIn: 'root'
})
export class ProductService {
    private http = inject(HttpClient);
    private apiUrl = environment.apiUrl + '/Products';

    getCategories(): Observable<Category[]> {
        return this.http.get<Category[]>(`${this.apiUrl}/categories`).pipe(
            retry({
                count: 3,
                delay: (error, retryCount) => {
                    return timer(1000 * retryCount);
                }
            }),
            catchError((error) => {
                return throwError(() => error);
            })
        );
    }
}

