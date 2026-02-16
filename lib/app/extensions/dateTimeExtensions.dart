import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// DateTime extension for formatting and utilities
extension DateTimeExtension on DateTime {
  /// Check if date is expired (is in the past)
  bool get isExpired => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isUpcoming => isAfter(DateTime.now());

  /// Get formatted date string (e.g., "9 Dec 2025")
  String get formattedDate => DateFormat('d MMM yyyy').format(this);

  /// Get formatted date with time (e.g., "9 Dec 2025, 1:28 PM")
  String get formattedDateTime => DateFormat('d MMM yyyy, h:mm a').format(this);

  /// Get time ago string (e.g., "2 hours ago", "3 days ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Get days remaining until this date (negative if expired)
  int get daysRemaining => difference(DateTime.now()).inDays;

  /// Get hours remaining until this date
  int get hoursRemaining => difference(DateTime.now()).inHours;

  /// Get formatted countdown string (e.g., "2 days 5 hours left")
  String get countdownString {
    final now = DateTime.now();
    if (isBefore(now)) return 'Expired';

    final diff = difference(now);
    final days = diff.inDays;
    final hours = diff.inHours - (days * 24);
    final minutes = diff.inMinutes - (days * 24 * 60) - (hours * 60);

    if (days > 0) {
      return '$days day${days > 1 ? 's' : ''} ${hours > 0 ? '$hours hour${hours > 1 ? 's' : ''}' : ''} left';
    } else if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}' : ''} left';
    } else if (minutes > 0) {
      return '$minutes minute${minutes > 1 ? 's' : ''} left';
    } else {
      return 'Ending soon';
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Check if date is within next 7 days
  bool get isWithinWeek {
    final now = DateTime.now();
    final weekLater = now.add(const Duration(days: 7));
    return isAfter(now) && isBefore(weekLater);
  }

  /// Convert to ISO string for API
  String get toISOString => toUtc().toIso8601String();

  /// Parse from API string (handles both UTC and local)
  static DateTime fromAPIString(String dateString) {
    try {
      return DateTime.parse(dateString).toLocal();
    } catch (e) {
      // If parsing fails, return current date
      return DateTime.now();
    }
  }

  /// Get formatted relative date (e.g., "Today", "Tomorrow", "In 3 days")
  String get relativeDate {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';

    final days = daysRemaining;
    if (days > 0) {
      return 'In $days day${days > 1 ? 's' : ''}';
    } else if (days < 0) {
      return '${days.abs()} day${days.abs() > 1 ? 's' : ''} ago';
    }
    return formattedDate;
  }
}

String formatTimeString(String timeStr) {
  try {
    if (timeStr.isEmpty) return 'Time not set';

    // Clean the string - remove extra spaces and make uppercase
    final cleanTime = timeStr.trim().toUpperCase();

    debugPrint("Original time: $timeStr");
    debugPrint("Clean time: $cleanTime");

    // Check if it has PM/AM suffix
    final hasPeriod = cleanTime.contains('PM') || cleanTime.contains('AM');

    // Extract the time part (remove PM/AM if present)
    String timePart = cleanTime;
    if (hasPeriod) {
      timePart = cleanTime.replaceAll('PM', '').replaceAll('AM', '').trim();
    }

    debugPrint("Time part: $timePart");

    // Split hours, minutes, seconds
    final parts = timePart.split(':');
    if (parts.length < 2) return timeStr;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    debugPrint("Hours: $hours, Minutes: $minutes");

    // Determine period (AM/PM)
    String period;
    int hour12;

    if (hasPeriod) {
      // If period is already specified in the string
      period = cleanTime.contains('PM') ? 'PM' : 'AM';
      hour12 = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
    } else {
      // If no period specified, assume 24-hour format
      if (hours == 0) {
        hour12 = 12;
        period = 'AM';
      } else if (hours < 12) {
        hour12 = hours;
        period = 'AM';
      } else if (hours == 12) {
        hour12 = 12;
        period = 'PM';
      } else {
        hour12 = hours - 12;
        period = 'PM';
      }
    }

    debugPrint("Hour12: $hour12, Period: $period");

    // Format as 12-hour time
    return '$hour12:${minutes.toString().padLeft(2, '0')} $period';
  } catch (e) {
    debugPrint("Error formatting time: $e");
    return timeStr;
  }
}


