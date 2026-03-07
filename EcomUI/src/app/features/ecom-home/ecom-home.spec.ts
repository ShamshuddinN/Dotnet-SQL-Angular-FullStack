import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EcomHome } from './ecom-home';

describe('EcomHome', () => {
  let component: EcomHome;
  let fixture: ComponentFixture<EcomHome>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EcomHome]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EcomHome);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
