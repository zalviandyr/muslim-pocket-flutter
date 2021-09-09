import 'package:intl/intl.dart';
import 'package:muslim_pocket/models/models.dart';

class ShalatHelper {
  static NextShalat getNextShalat(List<JadwalShalat> list) {
    DateTime dateTimeNow = DateTime.now();
    JadwalShalat schedule =
        list.where((e) => e.date.day == dateTimeNow.day).first;

    DateFormat format = DateFormat('HH:mm');
    DateTime timeNow =
        format.parse('${dateTimeNow.hour}:${dateTimeNow.minute}');
    DateTime imsyak = format.parse(schedule.imsyak);
    DateTime shubuh = format.parse(schedule.shubuh);
    DateTime rise = format.parse(schedule.rise);
    DateTime dhuha = format.parse(schedule.dhuha);
    DateTime dzuhur = format.parse(schedule.dzuhur);
    DateTime ashr = format.parse(schedule.ashr);
    DateTime magrib = format.parse(schedule.magrib);
    DateTime isya = format.parse(schedule.isya);

    NextShalat nextShalat;
    if (timeNow.compareTo(imsyak) == -1) {
      nextShalat = NextShalat(shalat: 'Imsyak', time: schedule.imsyak);
    } else if (timeNow.compareTo(imsyak) == 1 &&
        timeNow.compareTo(shubuh) == -1) {
      nextShalat = NextShalat(shalat: 'Shubuh', time: schedule.shubuh);
    } else if (timeNow.compareTo(shubuh) == 1 &&
        timeNow.compareTo(rise) == -1) {
      nextShalat = NextShalat(shalat: 'Terbit', time: schedule.rise);
    } else if (timeNow.compareTo(rise) == 1 && timeNow.compareTo(dhuha) == -1) {
      nextShalat = NextShalat(shalat: 'Dhuha', time: schedule.dhuha);
    } else if (timeNow.compareTo(dhuha) == 1 &&
        timeNow.compareTo(dzuhur) == -1) {
      nextShalat = NextShalat(shalat: 'Dzuhur', time: schedule.dzuhur);
    } else if (timeNow.compareTo(dzuhur) == 1 &&
        timeNow.compareTo(ashr) == -1) {
      nextShalat = NextShalat(shalat: 'Ashr', time: schedule.ashr);
    } else if (timeNow.compareTo(ashr) == 1 &&
        timeNow.compareTo(magrib) == -1) {
      nextShalat = NextShalat(shalat: 'Magrib', time: schedule.magrib);
    } else if (timeNow.compareTo(magrib) == 1 &&
        timeNow.compareTo(isya) == -1) {
      nextShalat = NextShalat(shalat: 'Isya', time: schedule.isya);
    } else {
      // jika lebih dari isya, maka ambil waktu isya hari selanjutnya
      JadwalShalat nextSchedule = list
          .where((e) => e.date.day == dateTimeNow.add(Duration(days: 1)).day)
          .first;

      nextShalat = NextShalat(shalat: 'Imsyak', time: nextSchedule.imsyak);
    }

    return nextShalat;
  }
}
