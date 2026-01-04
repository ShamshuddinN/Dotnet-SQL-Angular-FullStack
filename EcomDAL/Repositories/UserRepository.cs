using EcomDAL.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;

namespace EcomDAL.Repositories;

public class UserRepository : IUserRepository
{
    private readonly EcommerceDbContext _context;

    public UserRepository(EcommerceDbContext context)
    {
        _context = context;
    }

    public int RegisterUser(User user, string passwordHash, Address? address = null)
    {
        var emailParam = new SqlParameter("@Email", user.Email ?? (object)DBNull.Value);
        var passwordHashParam = new SqlParameter("@PasswordHash", passwordHash ?? (object)DBNull.Value);
        var fullNameParam = new SqlParameter("@FullName", user.FullName ?? (object)DBNull.Value);
        var genderParam = new SqlParameter("@Gender", user.Gender ?? (object)DBNull.Value);
        // Ensure DateOfBirth is passed correctly, or DBNull if needed (though SP seems to require it or has specific checks)
        // Checks in SP: IF (@DateOfBirth IS NULL ... ) RETURN -4. So it can be null passed, but will result in error.
        // User entity assumes DateOfBirth is DateTime (nullable? let's check User model).
        var dobParam = new SqlParameter("@DateOfBirth", user.DateOfBirth);
        var roleIdParam = new SqlParameter("@RoleId", user.RoleId);
        var phoneParam = new SqlParameter("@PhoneNumber", user.PhoneNumber ?? (object)DBNull.Value);

        var addressLine1Param = new SqlParameter("@AddressLine1", address?.AddressLine1 ?? (object)DBNull.Value);
        var addressLine2Param = new SqlParameter("@AddressLine2", address?.AddressLine2 ?? (object)DBNull.Value);
        var cityParam = new SqlParameter("@City", address?.City ?? (object)DBNull.Value);
        var stateParam = new SqlParameter("@State", address?.State ?? (object)DBNull.Value);
        var postalCodeParam = new SqlParameter("@PostalCode", address?.PostalCode ?? (object)DBNull.Value);
        var countryParam = new SqlParameter("@Country", address?.Country ?? (object)DBNull.Value);

        // EF Core 8 support for scalar return values from SQL
        var result = _context.Database
            .SqlQueryRaw<int>(
                "EXEC usp_RegisterUser @Email, @PasswordHash, @FullName, @Gender, @DateOfBirth, @RoleId, @PhoneNumber, @AddressLine1, @AddressLine2, @City, @State, @PostalCode, @Country",
                emailParam, passwordHashParam, fullNameParam, genderParam, dobParam, roleIdParam, phoneParam,
                addressLine1Param, addressLine2Param, cityParam, stateParam, postalCodeParam, countryParam
            )
            .AsEnumerable()
            .FirstOrDefault();

        return result;
    }

    public User? ValidateUser(string email, string password)
    {
        var user = GetUserByEmail(email);

        if (user != null)
        {
            bool isPasswordValid = BCrypt.Net.BCrypt.Verify(password, user.PasswordHash);
            if (isPasswordValid)
            {
                user.LastLoginAt = DateTime.UtcNow;
                _context.SaveChanges();
                return user;
            }
        }

        return null;
    }
    public User? GetUserByEmail(string email)
    {
        return _context.Users.FirstOrDefault(u => u.Email == email);
    }

    public User? GetUserById(int userId)
    {
        return _context.Users.FirstOrDefault(u => u.UserId == userId);
    }
}
