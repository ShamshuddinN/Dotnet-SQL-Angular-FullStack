using EcomDAL.Models;
using EcomDAL.Repositories;
using Microsoft.EntityFrameworkCore;
using System;

namespace EcomConsole;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Starting User Registration Test...");

        var connectionString = "Server=localhost,1433;Database=ECommerceDB;User ID=SA;Password=StrongPass@6473;Encrypt=False;TrustServerCertificate=True;";
        var optionsBuilder = new DbContextOptionsBuilder<EcommerceDbContext>();
        optionsBuilder.UseSqlServer(connectionString);

        using (var context = new EcommerceDbContext(optionsBuilder.Options))
        {
            // Seed Role if not exists
            var role = context.Roles.FirstOrDefault(r => r.RoleName == "Customer");
            if (role == null)
            {
                role = new Role { RoleName = "Customer", Description = "Regular Customer" };
                context.Roles.Add(role);
                context.SaveChanges();
                Console.WriteLine($"Seeded Role: {role.RoleId}");
            }

            var repo = new UserRepository(context);

            var newUser = new User
            {
                Email = $"testuser_{Guid.NewGuid()}@example.com",
                FullName = "Test User",
                Gender = "M",
                DateOfBirth = new DateOnly(1990, 1, 1),
                RoleId = role.RoleId,
                PhoneNumber = "1234567890"
            };

            var address = new Address
            {
                AddressLine1 = "123 Test St",
                City = "Test City",
                State = "TS",
                PostalCode = "12345",
                Country = "Test Country"
            };

            string passwordHash = "hashedpassword123";

            Console.WriteLine($"Attempting to register user: {newUser.Email}");
            try
            {
                int userId = repo.RegisterUser(newUser, passwordHash, address);
                Console.WriteLine($"Registration Result (UserId or ErrorCode): {userId}");

                if (userId > 0)
                {
                     Console.WriteLine("User registered successfully.");
                     
                     // Test Login Success
                     Console.WriteLine("Attempting to login with correct credentials...");
                     var loggedInUser = repo.ValidateUser(newUser.Email, passwordHash);
                     if (loggedInUser != null)
                     {
                         Console.WriteLine($"Login Successful! User: {loggedInUser.FullName}, LastLogin: {loggedInUser.LastLoginAt}");
                     }
                     else
                     {
                         Console.WriteLine("Login Failed with correct credentials.");
                     }

                     // Test Login Failure
                     Console.WriteLine("Attempting to login with wrong password...");
                     var failedUser = repo.ValidateUser(newUser.Email, "wrongpassword");
                     if (failedUser == null)
                     {
                         Console.WriteLine("Login Failed as expected with wrong credentials.");
                     }
                     else
                     {
                         Console.WriteLine("Login Unexpectedly Succeeded with wrong credentials.");
                     }
                }
                else
                {
                     Console.WriteLine("User registration failed.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
        }
    }
}
