import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/user.dart';
import '../model/pg.dart';
import '../model/floor.dart';
import '../model/room.dart';
import '../model/booking.dart';
import '../model/inmate.dart';
import '../model/payment.dart';
import 'package:intl/intl.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pg_manager.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT,password TEXT)");
    await db.execute(
        "CREATE TABLE pg (id INTEGER PRIMARY KEY AUTOINCREMENT,user_id INTEGER, name TEXT, address TEXT, floor_count TEXT)");
    await db.execute(
        "CREATE TABLE floors (id INTEGER PRIMARY KEY AUTOINCREMENT,pg_id INTEGER, room_count INTEGER)");
    await db.execute(
        "CREATE TABLE rooms (id INTEGER PRIMARY KEY AUTOINCREMENT,pg_id INTEGER, floor_id INTEGER,price INTEGER,bed_count INTEGER,bed_status TEXT)");
    await db.execute(
        "CREATE TABLE bookings (id INTEGER PRIMARY KEY AUTOINCREMENT,pg_id INTEGER, floor_id INTEGER, room_id INTEGER, name TEXT, phone INTEGER, address TEXT, booking_date INTEGER, movein_date INTEGER)");
    await db.execute(
        "CREATE TABLE checkins (id INTEGER PRIMARY KEY AUTOINCREMENT,pg_id INTEGER, floor_id INTEGER, room_id INTEGER, name TEXT, phone INTEGER, address TEXT, checkindate INTEGER)");
    await db.execute(
        "CREATE TABLE payments (id INTEGER PRIMARY KEY AUTOINCREMENT,pg_id INTEGER, floor_id INTEGER, room_id INTEGER, price INTEGER, checkin_id INTEGER, payment_date INTEGER)");

    print("Created tables");
  }

  // Future<List<Goal>> getGoals() async {
  //   var dbClient = await db;
  //   List<Map> list = await dbClient.rawQuery('SELECT * FROM Goal order by id DESC');
  //   List<Goal> goals = new List();
  //   for (int i = 0; i < list.length; i++) {
  //     goals.add(new Goal(list[i]["id"],list[i]["title"], list[i]["total"], list[i]["saved"],[],(list[i]["isFavorite"]=="1"?true:false)));
  //   }
  //   //print("ANURAN${goals[3].title}");
  //   return goals;
  // }

  Future<List<User>> getUser(String email, String password) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM users where email=\'${email}\' and password=\'${password}\'');
    print(list.length);
    List<User> users = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        users.add(new User(list[i]["id"].toString(), list[i]["name"],
            list[i]["phone"], list[i]["email"], list[i]["password"]));
      }
      print(users[0].name);
      return users;
    } else {
      print('users is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  Future<List<Floor>> getFloor(String pgID) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM floors where pg_id=\'${pgID}\'');
    print(list.length);
    List<Floor> floors = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        floors.add(new Floor(list[i]["id"].toString(),
            list[i]["pg_id"].toString(), list[i]["room_count"]));
      }

      return floors;
    } else {
      print('users is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  Future<List<Booking>> getBookings() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM bookings where movein_date >= \'${DateTime.now().millisecondsSinceEpoch}\'');
    print(list.length);
    List<Booking> bookings = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        bookings.add(new Booking(
            list[i]["id"],
            list[i]["pg_id"],
            list[i]["floor_id"],
            list[i]["room_id"],
            list[i]["name"],
            list[i]["phone"],
            list[i]["address"],
            list[i]["booking_date"],
            list[i]["movein_date"]));
      }

      return bookings;
    } else {
      print('bookings is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  Future<List<Inmate>> getInmates() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM checkins');
    print(list.length);
    List<Inmate> inmates = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        inmates.add(new Inmate(
            list[i]["id"],
            list[i]["pg_id"],
            list[i]["floor_id"],
            list[i]["room_id"],
            list[i]["name"],
            list[i]["phone"],
            list[i]["address"],
            list[i]["checkindate"]));
      }

      return inmates;
    } else {
      print('inmates is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  Future<List<PG>> getPG(String userID) async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM pg where user_id=\'${userID}\'');
    print(list.length);
    List<PG> pgs = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        pgs.add(new PG(
            list[i]["id"].toString(),
            list[i]["user_id"].toString(),
            list[i]["name"],
            list[i]["address"],
            int.parse(list[i]["floor_count"])));
      }
      return pgs;
    } else {
      print('pgs is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  Future<List<Payment>> getPayments() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM payments');
    print(list.length);
    List<Payment> payments = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        List<Map> inmatesList = await dbClient
            .rawQuery('SELECT * FROM checkins where id=\'${list[i]["id"]}\'');

        payments.add(new Payment(
            list[i]["id"],
            list[i]["pg_id"],
            list[i]["floor_id"],
            list[i]["room_id"],
            list[i]["checkin_id"],
            list[i]["price"],
            list[i]["payment_date"],
            inmatesList[0]["name"]));
      }
      return payments;
    } else {
      print('payments is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  void updatePayment(Payment payment) async {
    var dbClient = await db;
    dbClient.transaction((txn) async {
      await txn.rawInsert(
          'UPDATE payments SET payment_date=\'${DateTime.now().millisecondsSinceEpoch}\' where checkin_id=\'${payment.checkinID}\'');
    });
    print("payment updated");
  }

  Future<List<Payment>> getUpcomingPayments() async {
    var dbClient = await db;
    //DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM payments ');
    print(list.length);
    List<Payment> payments = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        List<Map> inmatesList = await dbClient
            .rawQuery('SELECT * FROM checkins where id=\'${list[i]["id"]}\'');

        payments.add(new Payment(
            list[i]["id"],
            list[i]["pg_id"],
            list[i]["floor_id"],
            list[i]["room_id"],
            list[i]["checkin_id"],
            list[i]["price"],
            list[i]["payment_date"],
            inmatesList[0]["name"]));
      }

      List<Payment> filteredList = payments
          .where((p) => (DateTime
                  .fromMillisecondsSinceEpoch(p.paymentDate)
                  .add(Duration(days: 30))
                  .millisecondsSinceEpoch >
              DateTime.now().millisecondsSinceEpoch))
          .toList();

      return filteredList;
    } else {
      print('payments is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  Future<List<Room>> getRoom(String pgID, String floorID) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        'SELECT * FROM rooms where pg_id=\'${pgID}\' and floor_id=\'${floorID}\'');
    print(list.length);
    List<Room> rooms = new List();
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        rooms.add(new Room(list[i]["id"], list[i]["pg_id"], list[i]["floor_id"],
            list[i]["price"], list[i]["bed_count"], list[i]["bed_status"]));
        print(rooms[i].bedStatus);
      }
      return rooms;
    } else {
      print('pgs is null');
      return null;
    }

    //print("ANURAN${payments[0].amount}");
  }

  void saveUser(
      String name, String email, String password, String phone) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO users(name, phone, email, password) VALUES(' +
              '\'' +
              name +
              '\'' +
              ',' +
              '\'' +
              phone +
              '\'' +
              ',' +
              '\'' +
              email +
              '\'' +
              ',' +
              '\'' +
              password +
              '\'' +
              ')');
    });
    print('user added');
  }

  void savePG(
      String userID, String name, String address, String flootCount) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO pg(user_id,name, address, floor_count) VALUES(' +
              '\'' +
              userID +
              '\'' +
              ',' +
              '\'' +
              name +
              '\'' +
              ',' +
              '\'' +
              address +
              '\'' +
              ',' +
              '\'' +
              flootCount +
              '\'' +
              ')');
    });

    List<Map> list = await dbClient
        .rawQuery('SELECT id FROM pg where user_id=\'${userID}\'');

    String id;
    if (list != null && list.length > 0) {
      for (int i = 0; i < list.length; i++) {
        id = list[i]["id"].toString();
      }
    }
    for (int i = 0; i < int.parse(flootCount); i++) {
      await dbClient.transaction((txn) async {
        return await txn.rawInsert(
            'INSERT INTO floors (pg_id,room_count) VALUES(' +
                '\'' +
                userID +
                '\'' +
                ',' +
                '\'' +
                0.toString() +
                '\'' +
                ')');
      });
    }
    print('pg added');
  }

  void saveBooking(
      int index,
      String pgID,
      String floorID,
      String roomID,
      String name,
      String phone,
      String address,
      String price,
      String moveinDate,
      String currentBedStatus) async {
    var dbClient = await db;

    var moveinTime = DateFormat("dd/MM/yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(moveinDate)));
    var todayTime = DateFormat("dd/MM/yyyy").format(DateTime.now());
    if (moveinTime == todayTime) {
      await dbClient.transaction((txn) async {
        return await txn.rawInsert(
            'INSERT INTO checkins(pg_id,floor_id, room_id, name,phone,address,checkindate) VALUES(' +
                '\'' +
                pgID +
                '\'' +
                ',' +
                '\'' +
                floorID +
                '\'' +
                ',' +
                '\'' +
                roomID +
                '\'' +
                ',' +
                '\'' +
                name +
                '\'' +
                ',' +
                '\'' +
                phone +
                '\'' +
                ',' +
                '\'' +
                address +
                '\'' +
                ',' +
                '\'' +
                DateTime.now().millisecondsSinceEpoch.toString() +
                '\'' +
                ')');
      });

      List<Map> list = await dbClient
          .rawQuery('SELECT id FROM checkins ORDER BY id DESC LIMIT 1');

      String id;
      if (list != null && list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          id = list[i]["id"].toString();
        }
        await dbClient.transaction((txn) async {
          return await txn.rawInsert(
              'INSERT INTO payments (pg_id,floor_id,room_id,price,checkin_id,payment_date) VALUES(' +
                  '\'' +
                  pgID +
                  '\'' +
                  ',' +
                  '\'' +
                  floorID +
                  '\'' +
                  ',' +
                  '\'' +
                  roomID +
                  '\'' +
                  ',' +
                  '\'' +
                  price +
                  '\'' +
                  ',' +
                  '\'' +
                  id +
                  '\'' +
                  ',' +
                  '\'' +
                  DateTime.now().millisecondsSinceEpoch.toString() +
                  '\'' +
                  ')');
        });
        print('room booked');
      }

      print("ANURAN currentBedStatus ${currentBedStatus}");
      List<String> bedStatus = currentBedStatus.split("");
      bedStatus[index] = '1';
      String bedStatusFinal = "";
      for (int i = 0; i < bedStatus.length; i++) {
        bedStatusFinal += bedStatus[i];
      }
      print("ANURAN currentBedStatus ${bedStatusFinal}");
      await dbClient.transaction((txn) async {
        return await txn.rawInsert(
            'UPDATE rooms set bed_status=\'${bedStatusFinal}\' where id=\'${roomID}\'');
      });
      print('room bed status updated');
    } else {
      await dbClient.transaction((txn) async {
        return await txn.rawInsert(
            'INSERT INTO bookings(pg_id,floor_id, room_id, name,phone,address,booking_date,movein_date) VALUES(' +
                '\'' +
                pgID +
                '\'' +
                ',' +
                '\'' +
                floorID +
                '\'' +
                ',' +
                '\'' +
                roomID +
                '\'' +
                ',' +
                '\'' +
                name +
                '\'' +
                ',' +
                '\'' +
                phone +
                '\'' +
                ',' +
                '\'' +
                address +
                '\'' +
                ',' +
                '\'' +
                DateTime.now().millisecondsSinceEpoch.toString() +
                '\'' +
                ',' +
                '\'' +
                moveinDate +
                '\'' +
                ')');
      });
    }
  }

  void deleteBooking(Booking booking) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawDelete(
          'DELETE from bookings where id=\'${booking.id.toString()}\'');
    });
  }

  void saveRoom(
      String pgID, String floorID, String price, String bedCount) async {
    String bedStatus = "";
    for (int i = 0; i < int.parse(bedCount); i++) {
      bedStatus += '0';
    }
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO rooms(pg_id,floor_id, price, bed_count,bed_status) VALUES(' +
              '\'' +
              pgID +
              '\'' +
              ',' +
              '\'' +
              floorID +
              '\'' +
              ',' +
              '\'' +
              price +
              '\'' +
              ',' +
              '\'' +
              bedCount +
              '\'' +
              ',' +
              '\'' +
              bedStatus +
              '\'' +
              ')');
    });
  }

  void checkin(Booking booking) async {
    var dbClient = await db;
    String currentBedStatus;
    List<Map> roomList = await dbClient.rawQuery(
        'SELECT * from rooms where pg_id=\'${booking.pgid.toString()}\' and floor_id=\'${booking.floorid.toString()}\' and id=\'${booking.roomid.toString()}\'');
    Room room;
    room = Room(
        roomList[0]["id"],
        roomList[0]["pg_id"],
        roomList[0]["floor_id"],
        roomList[0]["price"],
        roomList[0]["bed_count"],
        roomList[0]["bed_status"]);
    currentBedStatus = room.bedStatus;

    print("ANURAN currentBedStatus ${currentBedStatus}");
    List<String> bedStatus = currentBedStatus.split("");
    int index;
    for (int i = 0; i < bedStatus.length; i++) {
      if (bedStatus[i] == '0') {
        index = i;
        break;
      }
    }

    if (index != null && index < bedStatus.length) {
      bedStatus[index] = '1';
      String bedStatusFinal = "";
      for (int i = 0; i < bedStatus.length; i++) {
        bedStatusFinal += bedStatus[i];
      }
      print("ANURAN currentBedStatus ${bedStatusFinal}");
      await dbClient.transaction((txn) async {
        return await txn.rawInsert(
            'UPDATE rooms set bed_status=\'${bedStatusFinal}\' where id=\'${room.id.toString()}\'');
      });
      print('room bed status updated');

      await dbClient.transaction((txn) async {
        return await txn.rawInsert(
            'INSERT INTO checkins(pg_id,floor_id, room_id, name,phone,address,checkindate) VALUES(' +
                '\'' +
                booking.pgid.toString() +
                '\'' +
                ',' +
                '\'' +
                booking.floorid.toString() +
                '\'' +
                ',' +
                '\'' +
                booking.roomid.toString() +
                '\'' +
                ',' +
                '\'' +
                booking.name +
                '\'' +
                ',' +
                '\'' +
                booking.phone.toString() +
                '\'' +
                ',' +
                '\'' +
                booking.addres +
                '\'' +
                ',' +
                '\'' +
                DateTime.now().millisecondsSinceEpoch.toString() +
                '\'' +
                ')');
      });

      List<Map> list = await dbClient
          .rawQuery('SELECT id FROM checkins ORDER BY id DESC LIMIT 1');

      String id;
      if (list != null && list.length > 0) {
        for (int i = 0; i < list.length; i++) {
          id = list[i]["id"].toString();
        }
        await dbClient.transaction((txn) async {
          return await txn.rawInsert(
              'INSERT INTO payments (pg_id,floor_id,room_id,price,checkin_id,payment_date) VALUES(' +
                  '\'' +
                  booking.pgid.toString() +
                  '\'' +
                  ',' +
                  '\'' +
                  booking.floorid.toString() +
                  '\'' +
                  ',' +
                  '\'' +
                  booking.roomid.toString() +
                  '\'' +
                  ',' +
                  '\'' +
                  room.price.toString() +
                  '\'' +
                  ',' +
                  '\'' +
                  id +
                  '\'' +
                  ',' +
                  '\'' +
                  DateTime.now().millisecondsSinceEpoch.toString() +
                  '\'' +
                  ')');
        });
        print('room booked');
      }

      await dbClient.transaction((txn) async {
        txn.rawDelete(
            'DELETE FROM bookings where id=\'${booking.id.toString()}\'');
      });
    }
  }

  // Future<int> savePayment(String goalID,Payment payment) async {
  //   var dbClient = await db;
  //   await dbClient.transaction((txn) async {

  //     List<Map> goals = await txn.rawQuery('SELECT * FROM Goal WHERE id=\'${goalID}\'');
  //     Goal goal = Goal(goals[0]["id"],goals[0]["title"],goals[0]["total"],goals[0]["saved"],[],false);
  //     double totalSaved = goal.saved + payment.amount;
  //     if(!(totalSaved>goal.total)){
  //       await txn.rawInsert(
  //         'INSERT INTO Payment(goalID, amount, date) VALUES(' +
  //             '\'' +
  //             (payment.goalId)+
  //             '\'' +
  //             ',' +
  //             '\'' +
  //             payment.amount.toStringAsFixed(2) +
  //             '\'' +
  //             ',' +
  //             '\'' +
  //             payment.date+
  //             '\')');
  //       await txn.rawQuery('UPDATE Goal SET saved=\'${totalSaved}\' where id=\'${goalID}\'');
  //       return 0;
  //     }else {
  //       return 1;
  //     }

  //   });
  // }

  // Future<int> updatePayment(String goalID,Payment pay) async {
  //   var dbClient = await db;
  //   await dbClient.transaction((txn) async {

  //     List<Map> goals = await txn.rawQuery('SELECT * FROM Goal WHERE id=\'${goalID}\'');
  //     Goal goal = Goal(goals[0]["id"],goals[0]["title"],goals[0]["total"],goals[0]["saved"],[],false);

  //     List<Map> payments = await txn.rawQuery('SELECT * FROM Payment WHERE id=\'${pay.id}\'');
  //     Payment payment = Payment(payments[0]["id"].toString(),payments[0]["goalID"].toString(),payments[0]["date"],payments[0]["amount"]);
  //     double diff = payment.amount - pay.amount;
  //     double totalSaved=0.0;
  //     if(diff > 0){
  //       totalSaved = goal.saved - diff;
  //     }else {
  //       totalSaved = goal.saved + (-diff);
  //     }
  //     if(!(totalSaved>goal.total)){

  //       await txn.rawQuery('UPDATE Payment SET amount=\'${pay.amount}\' where id=\'${pay.id}\'');
  //       await txn.rawQuery('UPDATE Goal SET saved=\'${totalSaved}\' where id=\'${goalID}\'');

  //       return 0;
  //     }else {
  //       return 1;
  //     }

  //   });
  // }

  // Future<int> deletePayment(String goalID,Payment payment) async {
  //   var dbClient = await db;
  //   await dbClient.transaction((txn) async {

  //     await txn.rawQuery('DELETE FROM Payment where id=\'${payment.id}\'');

  //     List<Map> goals = await txn.rawQuery('SELECT * FROM Goal WHERE id=\'${goalID}\'');
  //     Goal goal = Goal(goals[0]["id"],goals[0]["title"],goals[0]["total"],goals[0]["saved"],[],false);
  //     double totalSaved = goal.saved - payment.amount;

  //     await txn.rawQuery('UPDATE Goal SET saved=\'${totalSaved}\' where id=\'${goalID}\'');

  //   });
  // }

  // Future<int> deleteGoal(String goalID) async {
  //   var dbClient = await db;
  //   await dbClient.transaction((txn) async {

  //     await txn.rawQuery('DELETE FROM Goal where id=\'${goalID}\'');

  //     await txn.rawQuery('DELETE FROM Payment where goalID=\'${goalID}\'');

  //   });
  // }
}
