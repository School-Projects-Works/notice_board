import 'package:flutter/material.dart';

List<String> departmentList = [
  "Information Technology Education",
  "Mathematics Education",
  "Accounting Studies",
  "Management Studies",
  "Construction Technology and Management Education",
  "Wood Science and Technology Education",
  "Architecture and Civil Engineering",
  "Automotive & Mechanical Technology Education",
  "Electrical & Electronics Technology Education",
  "Catering & Hospitality Education",
  "Fashion & Textiles Design Education",
  "Languages Education",
  "Interdisciplinary Studies",
  "Crop and Soil Science Education",
  "Animal Science Education",
  "Agricultural Economics and Extension Education",
  "Agricultural Engineering and Mechanisation Education",
  "Integrated Science Education",
  "Biological Science Education",
  "Chemistry Education",
  "Environmental Health and Sanitation Education",
  "Public Health Education",
  "Educational Leadership",
  "Educational Studies",
];

List<Color> darkColors = [
  const Color(0xFF1B1F32), // Dark Blue
  const Color(0xFF2C2F33), // Dark Gray
  const Color.fromARGB(255, 40, 5, 40), // Dark Slate Gray
  const Color(0xFF4B3F72), // Dark Purple
  const Color.fromARGB(255, 66, 7, 9), // Dark Cyan
  const Color(0xFF1A237E), // Dark Indigo
  const Color(0xFF4A148C), // Dark Violet
  const Color(0xFFB71C1C), // Dark Red
  const Color(0xFF0D47A1), // Dark Navy
  const Color(0xFF1B5E20), // Dark Green
];


List<Map<String, dynamic>> notices = [
  {
    "title": "Welcome to the New Academic Year!",
    'images':[
      'https://www.wishesmsg.com/wp-content/uploads/welcome-message-for-students-for-new-academic-year.jpg'
    ],
    "content": """
# Welcome to the New Academic Year!

We are thrilled to **welcome** all students, faculty, and staff to the new academic year. This year, we have a lot of exciting events and opportunities lined up.

## Key Highlights:
- **Orientation Week**: A week full of activities to help new students settle in.
- **Guest Lectures**: We have renowned speakers lined up for various departments.
- **Workshops**: Skill development workshops will be held throughout the semester.

### Important Dates:
- **August 15**: Orientation starts
- **August 22**: First day of classes

We look forward to a productive and enjoyable year ahead!
"""
  },
  {
    "title": "Library Hours Update",
    "content": """

Dear Students,

We are pleased to announce the **extended hours** for the university library starting next week.

### New Library Hours:
- **Monday to Friday**: 8:00 AM - 10:00 PM
- **Saturday**: 9:00 AM - 6:00 PM
- **Sunday**: 1:00 PM - 5:00 PM

Please make sure to carry your student ID for access. For any queries, contact the library help desk at [library@university.edu](mailto:library@university.edu).

Happy Studying!
"""
  },
  {
    "title": "Upcoming Career Fair",
    "content": """

Attention all students!

The **annual career fair** is scheduled for **September 10** in the main auditorium. This is a great opportunity to meet potential employers and learn about various career paths.

## Participating Companies:
- **Google**
- **Amazon**
- **Microsoft**
- **Tesla**

### Tips for Success:
1. **Dress Professionally**: First impressions matter.
2. **Bring Resumes**: Have multiple copies of your resume.
3. **Prepare Questions**: Show your interest and knowledge about the companies.

We hope to see you all there!
"""
  },
  {
    "title": "Midterm Exam Schedule",
    "content": """

Dear Students,

The **midterm exams** are approaching. Please find the schedule below:

## Exam Dates:
- **October 15**: Mathematics
- **October 16**: Information Technology
- **October 17**: Accounting
- **October 18**: Management Studies

### Important Instructions:
- **Be on Time**: Latecomers will not be allowed.
- **Bring ID**: Student ID is mandatory.
- **No Electronic Devices**: Except approved calculators.

Prepare well and good luck!
"""
  },
  {
    "title": "New Cafeteria Menu",
    "content": """

We are excited to introduce a **new menu** at the university cafeteria. The new menu includes a variety of healthy and delicious options.

## Highlights:
- **Salads**: Fresh and organic.
- **Vegan Options**: Available daily.
- **Daily Specials**: Different cuisines every day.

### Feedback:
We value your feedback. Please share your suggestions at [cafeteria@university.edu](mailto:cafeteria@university.edu).

Bon Appétit!
"""
  },
  {
    "title": "Guest Lecture: Dr. Jane Smith",
    "content": """

We are honored to host **Dr. Jane Smith**, a renowned expert in **Artificial Intelligence**, for a guest lecture on **September 20**.

## Lecture Details:
- **Topic**: Advances in Machine Learning
- **Date**: September 20
- **Time**: 3:00 PM - 5:00 PM
- **Venue**: Lecture Hall 1

### About the Speaker:
Dr. Jane Smith is a professor at **MIT** and has published over **50 papers** in leading journals.

Don't miss this opportunity to learn from a leading expert!
"""
  },
  {
    "title": "Campus Safety Guidelines",
    'images': [
      'https://miro.medium.com/v2/resize:fit:1400/0*0lwCBtos5DNrZc4g.jpg',
      'https://piedmontcc.edu/wp-content/uploads/2023/09/PCC-Campus-Safety-Tips-Flyer-2023-.png'
    ],
    "content": """

The safety of our students and staff is our top priority. Please adhere to the following guidelines to ensure a safe campus environment.

## Guidelines:
1. **Wear Masks**: Masks are mandatory in all indoor spaces.
2. **Social Distancing**: Maintain at least 6 feet distance.
3. **Hand Hygiene**: Wash hands frequently or use sanitizers.
4. **Report Symptoms**: If you feel unwell, stay home and report to the health center.

### Health Center Contact:
- **Phone**: (123) 456-7890
- **Email**: [healthcenter@university.edu](mailto:healthcenter@university.edu)

Stay safe and healthy!
"""
  },
  {
    "title": "Join the University Choir",
    'images':[
      'https://pbs.twimg.com/media/FmGnRcUWIAE0dRq.jpg'
    ],
    "content": """

Do you love singing? Join the **university choir** and be a part of an amazing musical journey.

## Benefits:
- **Professional Training**: Learn from experienced vocal coaches.
- **Performances**: Participate in various events and concerts.
- **Community**: Meet and connect with fellow music enthusiasts.

### How to Join:
- **Auditions**: Held on **August 30**
- **Venue**: Music Room 101
- **Contact**: [choir@university.edu](mailto:choir@university.edu)

We look forward to hearing your beautiful voices!
"""
  },
  {
    "title": "New Parking Regulations",
    "content": """
# New Parking Regulations

Starting next month, new parking regulations will be in effect on campus to ensure fair usage and safety.

## Key Points:
- **Parking Permits**: Required for all vehicles.
- **Designated Areas**: Park only in designated zones.
- **No Overnight Parking**: Unless with special permission.

### Penalties:
Non-compliance will result in fines or towing of the vehicle.

For more information, visit the [parking office](https://university.edu/parking) or email [parking@university.edu](mailto:parking@university.edu).

Thank you for your cooperation!
"""
  },
  {
    "title": "Student Exchange Program",
    "content": """

Explore new cultures and enhance your academic experience by participating in the **Student Exchange Program**.

## Program Details:
- **Duration**: One semester
- **Destinations**: Partner universities in Europe, Asia, and America.
- **Eligibility**: Open to second-year and above students with a GPA of 3.0 and above.

### Application Process:
1. **Submit Application**: Online at the [exchange program portal](https://university.edu/exchange).
2. **Interviews**: Conducted by the selection committee.
3. **Results**: Announced by November 1.

Don't miss this opportunity to study abroad!
"""
  },
];
