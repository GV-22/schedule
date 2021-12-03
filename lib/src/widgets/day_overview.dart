
// dynamic _getDayTaskStats(BuildContext context) {
//     final dayTasks = Provider.of<DataProvider>(context, listen: false)
//         .getTasksByDay(_dayCode.dayCode);

//     int minutes = 0;

//     for (var task in dayTasks) {
//       final startTime = formatToTimeOfDay(task.startTime);
//       final endTime = formatToTimeOfDay(task.endTime);

//       final startTimeInMinutes = startTime.hour * 60 + startTime.minute;
//       final endTimeInMinutes = endTime.hour * 60 + endTime.minute;

//       minutes += endTimeInMinutes - startTimeInMinutes;
//     }

//     return {
//       "taskCounts": dayTasks.length,
//       "totalDuration": minutes,
//     };
//   }