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

        if (result > 0) // Successful registration returns new UserID
        {
            user = _userRepository.GetUserById(result);

            if (user != null)
            {
                var token = GenerateJwtToken(user);
                SetTokenCookie(token);
                return Ok(new { Message = "User registered successfully", UserId = result });
            }
            
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
        SetTokenCookie(token);

        return Ok(new { Message = "Login successful" });
    }

    [HttpPost("logout")]
    public IActionResult Logout()
    {
        Response.Cookies.Delete("jwt");
        return Ok(new { Message = "Logged out successfully" });
    }

    private void SetTokenCookie(string token)
    {
        var cookieOptions = new CookieOptions
        {
            HttpOnly = true,
            Secure = true, // Set to true in Production, but good for local if using https or localhost constraints often allow it
            SameSite = SameSiteMode.Strict,
            Expires = DateTime.UtcNow.AddHours(2)
        };
        Response.Cookies.Append("jwt", token, cookieOptions);
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

    [HttpGet("me")]
    [Authorize]
    [SwaggerOperation(Summary = "Get current user", Description = "Retrieves details of the currently logged-in user.")]
    [SwaggerResponse(200, "User details returned")]
    [SwaggerResponse(401, "Not authenticated")]
    public IActionResult GetMe()
    {
        var params_identity = HttpContext.User.Identity as ClaimsIdentity;
        //var claims = new List<Claim>();
        var map_claims = new Dictionary<string, string>();
        if(params_identity != null){
            IEnumerable<Claim> claims = params_identity.Claims;
             foreach(var claim in claims){
                map_claims[claim.Type] = claim.Value;
             }
        }
        
        return Ok(new 
        { 
            UserId = map_claims[ClaimTypes.NameIdentifier],
            FullName = map_claims[ClaimTypes.Name],
            Email = map_claims[ClaimTypes.Email],
            Role = map_claims[ClaimTypes.Role]
        });
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
