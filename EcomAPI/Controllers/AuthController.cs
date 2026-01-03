using EcomAPI.DTOs;
using EcomDAL.Models;
using EcomDAL.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Swashbuckle.AspNetCore.Annotations;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace EcomAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly IUserRepository _userRepository;
    private readonly IConfiguration _configuration;

    public AuthController(IUserRepository userRepository, IConfiguration configuration)
    {
        _userRepository = userRepository;
        _configuration = configuration;
    }

    [HttpPost("register")]
    [SwaggerOperation(Summary = "Register a new user", Description = "Creates a new user account with optional address.")]
    [SwaggerResponse(200, "User registered successfully")]
    [SwaggerResponse(400, "Invalid input or registration failed")]
    [AllowAnonymous]
    public IActionResult Register([FromBody] UserRegisterDto request)
    {
        // Map DTO to User model
        var user = new User
        {
            Email = request.Email,
            FullName = request.FullName,
            Gender = request.Gender,
            DateOfBirth = request.DateOfBirth,
            RoleId = request.RoleId,
            PhoneNumber = request.PhoneNumber,
            CreatedAt = DateTime.UtcNow,
            IsActive = true
        };

        Address? address = null;
        if (!string.IsNullOrEmpty(request.AddressLine1))
        {
            address = new Address
            {
                AddressLine1 = request.AddressLine1,
                AddressLine2 = request.AddressLine2,
                City = request.City,
                State = request.State,
                PostalCode = request.PostalCode,
                Country = request.Country
            };
        } 
        
        // Hash password using BCrypt
        string passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

        var result = _userRepository.RegisterUser(user, passwordHash, address);

        if (result > 0) // Assuming > 0 means UserId or Success
        {
            return Ok(new { Message = "User registered successfully", UserId = result });
        }
        else if (result == -1)
        {
             return BadRequest(new { Message = "User with this email already exists." });
        }

        return BadRequest(new { Message = "Registration failed." });
    }

    [HttpPost("login")]
    [SwaggerOperation(Summary = "Login user", Description = "Authenticates user and returns JWT token.")]
    [SwaggerResponse(200, "Login successful", typeof(object))] // returns token object
    [SwaggerResponse(401, "Invalid credentials")]
    [AllowAnonymous]
    public IActionResult Login([FromBody] UserLoginDto request)
    {
        var user = _userRepository.ValidateUser(request.Email, request.Password);
        
        if (user == null)
        {
             return Unauthorized(new { Message = "Invalid email or password" });
        }

        if (user.IsActive != true)
        {
             return Unauthorized(new { Message = "User account is inactive" });
        }

        var token = GenerateJwtToken(user);

        return Ok(new { Token = token, Message = "Login successful" });
    }

    private string GenerateJwtToken(User user)
    {
        var jwtSettings = _configuration.GetSection("Jwt");
        var key = Encoding.ASCII.GetBytes(jwtSettings["Key"]!);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
            new Claim(ClaimTypes.Name, user.FullName ?? "User"),
            new Claim(ClaimTypes.Email, user.Email),
            new Claim(ClaimTypes.Role, GetRoleName(user.RoleId)) 
        };

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddHours(2), // Token valid for 2 hours
            Issuer = jwtSettings["Issuer"],
            Audience = jwtSettings["Audience"],
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    private string GetRoleName(int roleId)
    {
        if (Enum.IsDefined(typeof(RoleType), roleId))
        {
            return ((RoleType)roleId).ToString();
        }
        return "User";
    }
}
