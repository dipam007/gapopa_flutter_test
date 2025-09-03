/// Weapons provide damage.
mixin Weapon on Item {
  int get damage;
}

/// Armor provides defense.
mixin Armor on Item {
  int get defense;
}

class Sword extends Item with Weapon {
  @override
  final int damage;
  Sword(this.damage);
}

class Shield extends Item with Weapon, Armor {
  @override
  final int damage;
  @override
  final int defense;

  Shield(this.damage, this.defense);
}

class Helmet extends Item with Armor {
  @override
  final int defense;
  Helmet(this.defense);
}

class Chestplate extends Item with Armor {
  @override
  final int defense;
  Chestplate(this.defense);
}

/// Object equipable by a [Character].
abstract class Item {}

/// Entity equipping [Item]s.
class Character {
  Item? leftHand;
  Item? rightHand;
  Item? hat;
  Item? torso;
  Item? legs;
  Item? shoes;

  /// Returns all the [Item]s equipped by this [Character].
  Iterable<Item> get equipped =>
      [leftHand, rightHand, hat, torso, legs, shoes].whereType<Item>();

  /// Returns the total damage of this [Character].
  int get damage =>
      equipped.whereType<Weapon>().fold(0, (sum, w) => sum + w.damage);

  /// Returns the total defense of this [Character].
  int get defense =>
      equipped.whereType<Armor>().fold(0, (sum, a) => sum + a.defense);

  /// Equips the provided [item], meaning putting it to the corresponding slot.
  ///
  /// If there's already a slot occupied, then throws a [OverflowException].
  void equip(Item item) {
    if (item is Weapon) {
      if (leftHand == null) {
        leftHand = item;
      } else if (rightHand == null) {
        rightHand = item;
      } else {
        throw OverflowException("Both hands are already full!");
      }
    } else if (item is Helmet) {
      if (hat == null) {
        hat = item;
      } else {
        throw OverflowException("Hat slot is already occupied!");
      }
    } else if (item is Chestplate) {
      if (torso == null) {
        torso = item;
      } else {
        throw OverflowException("torso slot is already occupied!");
      }
    } else {
      throw Exception("Unsupported item type");
    }
  }
}

/// [Exception] indicating there's no place left in the [Character]'s slot.
class OverflowException implements Exception {
  final String message;

  OverflowException([this.message = "Slot already occupied"]);

  @override
  String toString() => "OverflowException: $message";
}

void main() {
  // Implement mixins to differentiate [Item]s into separate categories to be
  // equipped by a [Character]: weapons should have some damage property, while
  // armor should have some defense property.
  //
  // [Character] can equip weapons into hands, helmets onto hat, etc.

  final hero = Character();
    try {
      hero.equip(Sword(10)); // goes to left hand
      hero.equip(Shield(5, 3)); // goes to right hand
      hero.equip(Helmet(2)); // goes to hat
      hero.equip(Chestplate(4)); // goes to torso

      hero.equip(Sword(12)); // throws OverflowException, both hands full
      print("Damage: ${hero.damage}"); // Damage: 15 (10 + 5)
      print("Defense: ${hero.defense}"); // Defense: 9 (3 + 2 + 4)
      return Text("Damage: ${hero.damage}\nDefense: ${hero.defense}");
    } on OverflowException catch (e) {
      print(e); // Prints: OverflowException: Both hands are already full!
      return Text("$e");
    }
}


// <------------------- Task-3 --------------------->
// /// Object equipable by a [Character].
// abstract class Item {}

// /// Entity equipping [Item]s.
// class Character {
//   Item? leftHand;
//   Item? rightHand;
//   Item? hat;
//   Item? torso;
//   Item? legs;
//   Item? shoes;

//   /// Returns all the [Item]s equipped by this [Character].
//   Iterable<Item> get equipped =>
//       [leftHand, rightHand, hat, torso, legs, shoes].whereType<Item>();

//   /// Returns the total damage of this [Character].
//   int get damage {
//     // TODO: Implement me.
//     return 0;
//   }

//   /// Returns the total defense of this [Character].
//   int get defense {
//     // TODO: Implement me.
//     return 0;
//   }

//   /// Equips the provided [item], meaning putting it to the corresponding slot.
//   ///
//   /// If there's already a slot occupied, then throws a [OverflowException].
//   void equip(Item item) {
//     // TODO: Implement me.
//   }
// }

// /// [Exception] indicating there's no place left in the [Character]'s slot.
// class OverflowException implements Exception {}

// void main() {
//   // Implement mixins to differentiate [Item]s into separate categories to be
//   // equipped by a [Character]: weapons should have some damage property, while
//   // armor should have some defense property.
//   //
//   // [Character] can equip weapons into hands, helmets onto hat, etc.
// }
