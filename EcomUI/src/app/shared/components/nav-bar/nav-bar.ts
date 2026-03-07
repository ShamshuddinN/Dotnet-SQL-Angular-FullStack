import { CommonModule } from '@angular/common';
import { Component, inject, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ProductService, Category } from '../../../core/services/product.service';
import { Subject } from 'rxjs';
import { takeUntil, finalize } from 'rxjs/operators';

@Component({
  selector: 'app-nav-bar',
  imports: [CommonModule, RouterLink],
  templateUrl: './nav-bar.html',
  styleUrl: './nav-bar.css',
})
export class NavBar implements OnInit, OnDestroy {
  private productService = inject(ProductService);
  private cdr = inject(ChangeDetectorRef);
  private destroy$ = new Subject<void>();

  public isMobileMenuOpen: boolean = false;
  public categories: Category[] = [];
  public isLoadingCategories: boolean = false;
  public hasErrorLoadingCategories: boolean = false;

  ngOnInit() {
    // Load categories immediately
    this.loadCategories();
  }

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
  }

  loadCategories() {
    this.isLoadingCategories = true;
    this.hasErrorLoadingCategories = false;
    this.cdr.markForCheck();
    this.productService.getCategories()
      .pipe(
        takeUntil(this.destroy$),
        finalize(() => {})
      )
      .subscribe({
        next: (data: Category[]) => {
          this.categories = data;
          this.isLoadingCategories = false;
          this.cdr.markForCheck();
        },
        error: (err) => {
          this.hasErrorLoadingCategories = true;
          this.isLoadingCategories = false;
          this.cdr.markForCheck();
        }
      });
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen = !this.isMobileMenuOpen;
  }

}
