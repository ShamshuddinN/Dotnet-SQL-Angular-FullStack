using System.ComponentModel.DataAnnotations;

namespace EcomAPI.DTOs;

public class UserRegisterDto
{
    [Required]
    [EmailAddress]
    public string Email { get; set; } = null!;

    [Required]
    [MinLength(6)]
    public string Password { get; set; } = null!;

    [Required]
    public string FullName { get; set; } = null!;

    public string? Gender { get; set; }

    [Required]
    public DateOnly DateOfBirth { get; set; }

    [Required]
    public int RoleId { get; set; } // 2: Admin, 3: Customer, etc.

    public string? PhoneNumber { get; set; }

    // Address Fields
    public string? AddressLine1 { get; set; }
    public string? AddressLine2 { get; set; }
    public string? City { get; set; }
    public string? State { get; set; }
    public string? PostalCode { get; set; }
    public string? Country { get; set; }
}
