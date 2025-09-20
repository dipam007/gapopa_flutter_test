/// Unique identifier for a [User], always UUIDv4 format.
class UserId {
  final String value;
  UserId(this.value) {
    if (value.length != 36) {
      throw ArgumentError('UserId must be 36 characters long.');
    }
    // Regex check for UUIDv4 format
    final uuidV4Regex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-'
      r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    if (!uuidV4Regex.hasMatch(value)) {
      throw ArgumentError('UserId must be a valid UUIDv4 format.');
    }
  }

  @override
  String toString() => value;
}

/// User's name, 4–32 characters, alphabetic only.
class UserName {
  final String value;
  UserName(this.value) {
    if (value.length < 4 || value.length > 32) {
      throw ArgumentError('UserName must be 4–32 characters long.');
    }
    if (!RegExp(r'^[A-Za-z]+$').hasMatch(value)) {
      throw ArgumentError('UserName must contain only letters.');
    }
  }
  @override
  String toString() => value;
}

/// Short biography, max 255 characters.
class UserBio {
  final String value;
  UserBio(this.value) {
    if (value.length > 255) {
      throw ArgumentError('UserBio must not exceed 255 characters.');
    }
  }
  @override
  String toString() => value;
}

/// Represents an application user.
///
/// A [User] has a unique [UserId], an optional [UserName],
/// and an optional [UserBio].
class User {
  const User({required this.id, this.name, this.bio});

  /// TODO: ID should be always 36 characters long and be in [UUIDv4] format.
  ///
  /// [UUIDv4]: https://en.wikipedia.org/wiki/Universally_unique_identifier
  /// Unique identifier in UUIDv4 format.
  final UserId id;

  /// TODO: Name should be always 4 - 32 characters long, contain only
  ///       alphabetical letters.
  /// Display name, if provided.
  final UserName? name;

  /// TODO: Biography must be no longer than 255 characters.
  /// Short biography, up to 255 characters.
  final UserBio? bio;
}

class Backend {
  final Map<String, User> _storage = {};

  /// Fetches a [User] by [UserId].
  Future<User> getUser(UserId id) async =>
      _storage[id.value] ?? User(id: id); // Return stored user or empty user

  /// Updates a [User] by [UserId].
  Future<void> putUser(UserId id, {UserName? name, UserBio? bio}) async {
    final existing = _storage[id.value];

    _storage[id.value] = User(
      id: id,
      name: name ?? existing?.name,
      bio: bio ?? existing?.bio,
    );
  }
}

/// Application service for user-related operations.
class UserService {
  UserService(this.backend);

  /// Backend that provides persistence.
  final Backend backend;

  /// Retrieves a [User] by [UserId].
  Future<User> get(UserId id) async {
    return backend.getUser(id);
  }

  /// Updates a [User].
  Future<void> update(User user) async {
    return backend.putUser(user.id, name: user.name, bio: user.bio);
  }
}

void main() async {
  // Do the following:
  // - fix missing explicit types;
  // - decompose the types using the newtype idiom;
  // - add documentation following the "Effective Dart: Documentation"
  //   guidelines.

  final backend = Backend();
  final service = UserService(backend);

  final userId = UserId("550e8400-e29b-41d4-a716-446655440000");

  final User user = await service.get(userId);
  print("User ID: ${user.id}");
  print("User Name: ${user.name}");
  print("User Bio: ${user.bio}");

  await service.update(
    User(
      id: userId,
      name: UserName("Dipam"),
      bio: UserBio("Flutter Developer"),
    ),
  );

  final User updatedUser = await service.get(userId);
  print("User ID: ${updatedUser.id}");
  print("User Name: ${updatedUser.name}");
  print("User Bio: ${updatedUser.bio}");
}
