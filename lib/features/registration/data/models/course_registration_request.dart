class CourseRegistrationRequest {
  final int courseId;
  final List<int> sectionIds;

  const CourseRegistrationRequest({
    required this.courseId,
    required this.sectionIds,
  });

  Map<String, dynamic> toJson() => {
        'course_id': courseId,
        'sections': sectionIds,
      };
}
