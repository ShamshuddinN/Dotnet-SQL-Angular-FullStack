using EcomDAL.Models;

namespace EcomDAL.Repositories;

public interface IUserRepository
{
    /// <summary>
    /// Registers a new user using the stored procedure usp_RegisterUser.
    /// </summary>
    /// <param name="user">The user entity properties.</param>
    /// <param name="passwordHash">The hashed password.</param>
    /// <param name="address">Optional address information.</param>
    /// <returns>The UserID of the newly created user, or an error code.</returns>
    int RegisterUser(User user, string passwordHash, Address? address = null);

    /// <summary>
    /// Validates a user's credentials and updates their LastLoginAt timestamp.
    /// </summary>
    /// <param name="email">The user's email.</param>
    /// <param name="passwordHash">The hashed password to verify.</param>
    /// <returns>The User object if validation succeeds, null otherwise.</returns>
    /// <summary>
    /// Retrieves a user by their email address.
    /// </summary>
    /// <param name="email">The user's email.</param>
    /// <returns>The User object if found, null otherwise.</returns>
    User? GetUserByEmail(string email);

    User? ValidateUser(string email, string passwordHash);
}
