// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Questionnaire/question_2.dart';

class QuestionOne extends StatefulWidget {
  List<String> responses = [];

  final List<String> nonprofits = [
  "Education",
  "Mental health",
  "Sports",
  "Food",
  "Environmental conservation",
  "Animal welfare",
  "Healthcare",
  "Arts and culture",
  "Human rights",
  "Community development",
  "Disaster relief",
  "Economic development",
  "Housing",
  "International aid",
  "Legal aid",
  "Refugee support",
  "Technology access",
  "Wildlife conservation",
  "Youth development",
  "Senior care",
  "Gender equality",
  "Microfinance",
  "Clean energy",
  "Literacy",
  "Peacebuilding",
  "Veterans support",
  "Public policy",
  "Civic engagement",
  "Homelessness",
  "Drug rehabilitation",
  "Disease prevention",
  "Water sanitation",
  "Climate action",
  "Child welfare",
  "Indigenous rights",
  "Cultural preservation",
  "Emergency response",
  "Food security",
  "Labor rights",
  "Social justice",
  "Urban planning",
  "Sustainable agriculture",
  "Transparency and accountability",
  "Inclusive education",
  "Orphan care",
  "Conservation",
  "Fair trade",
  "Access to justice",
  "Refugee resettlement",
  "Community health",
  "Science education",
  "Entrepreneurship",
  "Armed forces support",
  "Consumer protection",
  "Public health",
  "Humanitarian aid",
  "Digital literacy",
  "Community empowerment",
  "Peace education",
  "Prison reform",
  "Environmental justice",
  "Inclusive employment",
  "Immigration support",
  "Maternal health",
  "Art therapy",
  "Child protection",
  "Clean water",
  "Democracy promotion",
  "Equal access",
  "Health education",
  "Rural development",
  "Space exploration",
  "Freedom of speech",
  "Justice reform",
  "Human trafficking prevention",
  "Nutrition",
  "STEM education",
  "Community resilience",
  "Sport for development",
  "Waste management",
  "Historic preservation",
  "Access to information",
  "Disability rights",
  "Media literacy",
  "Primate conservation",
  "Social entrepreneurship",
  "Inclusive design",
  "Peacekeeping",
  "Consumer rights",
  "Tuberculosis eradication",
  "Gender equity",
  "Veterinary care",
  "Safe housing",
  "Climate resilience",
  "Music therapy",
  "Community renewal",
  "Marine conservation",
  "Environmental education",
  "Social services",
  "Urban revitalization",
  "Migrant rights",
  "Pollution control",
  "Affordable housing",
  "Aging services",
  "Agricultural development",
  "Air quality",
  "Anti-bullying",
  "Anti-corruption",
  "Anti-discrimination",
  "Aquatic conservation",
  "Arts education",
  "Assistive technology",
  "Biodiversity",
  "Biotechnology",
  "Breast cancer awareness",
  "Cancer research",
  "Cataract surgery",
  "Child marriage prevention",
  "Climate adaptation",
  "Community gardens",
  "Community housing",
  "Conflict resolution",
  "Corporate responsibility",
  "Crisis intervention",
  "Cultural exchange",
  "Deaf and hard of hearing services",
  "Digital equity",
  "Disaster preparedness",
  "Diversity and inclusion",
  "Domestic violence prevention",
  "Early childhood education",
  "Elder abuse prevention",
  "Environmental advocacy",
  "Ex-offender support",
  "Family planning",
  "Financial literacy",
  "Food distribution",
  "Forestry conservation",
  "Freedom of the press",
  "Girl empowerment",
  "Green building",
  "Health access",
  "HIV/AIDS prevention",
  "Homeless shelters",
  "Humanitarian research",
  "Inclusive tourism",
  "Indigenous healthcare",
  "Innovation labs",
  "Interfaith dialogue",
  "Job creation",
  "Job training",
  "Land conservation",
  "Legal reform",
  "LGBTQ+ rights",
  "Literacy programs",
  "Malaria prevention",
  "Marine biodiversity",
  "Medical research",
  "Mental health services",
  "Mentorship programs",
  "Microgrants",
  "Mobile clinics",
  "Natural disaster relief",
  "Occupational safety",
  "Ocean cleanup",
  "Open government",
  "Organ donation",
  "Parental support",
  "Parks and recreation",
  "Patient advocacy",
  "Pediatric care",
  "Philanthropy",
  "Physical fitness",
  "Pollinator protection",
  "Public art",
  "Public transportation",
  "Racial justice",
  "Recycling",
  "Reforestation",
  "Renewable energy",
  "Restorative justice",
  "Road safety",
  "Rural healthcare",
  "Sanitation",
  "School supplies",
  "Sex education",
  "Sexual violence prevention",
  "Shelter animal care",
  "Social innovation",
  "Sustainable development",
  "Sustainable fisheries",
  "Teacher training",
  "Transgender rights",
  "Transportation access",
  "Trauma care",
  "Tree planting",
  "Urban farming",
  "Urban infrastructure",
  "Violence prevention",
  "Water conservation",
  "Wildlife rehabilitation",
  "Women's rights",
  "Youth entrepreneurship",
  "Zero waste",
  "Zoonotic disease prevention",
  "Addiction recovery",
  "Affordable childcare",
  "AIDS education",
  "Anti-nuclear advocacy",
  "Bee conservation",
  "Bird conservation",
  "Blind services",
  "Blood donation",
  "Carbon offset",
  "Clean cooking",
  "Community policing",
  "Consumer education",
  "Corporate philanthropy",
  "Cultural diversity",
  "Cybersecurity education",
  "Dementia care",
  "Diabetes prevention",
  "Disaster risk reduction",
  "Domestic adoption",
  "Energy conservation",
  "Family therapy",
  "Free clinics",
  "Green jobs",
  "Habitat restoration",
  "Health informatics",
  "Heritage conservation",
  "Horticultural therapy",
  "Humanitarian logistics",
  "Indigenous education",
  "Labor market integration",
  "LGBTQ+ healthcare",
  "Local food systems",
  "Malnutrition",
  "Maternal mortality reduction",
  "Medical supply distribution",
  "Mobile libraries",
  "Molecular biology",
  "Mosquito control",
  "Nature therapy",
  "Nonviolence",
  "Online education",
  "Open source development",
  "Park maintenance",
  "Patient transport",
  "Pediatric research",
  "Pesticide alternatives",
  "Plastic pollution",
  "Playground safety",
  "Pollution prevention",
  "Prison education",
  "Pro bono legal services",
  "Public broadcasting",
  "Public safety",
  "Radiation safety",
  "Rainwater harvesting",
  "Refugee education",
  "Road development",
  "Rural electrification",
  "Safe driving",
  "Safe motherhood",
  "School health",
  "Seniors' digital literacy",
  "Sex worker rights",
  "Shelter construction",
  "Social housing",
  "Solar power",
  "Special education",
  "Sports outreach",
  "Sustainable business",
  "Sustainable tourism",
  "Teacher appreciation",
  "Textbook distribution",
  "Toxic waste cleanup",
  "Urban forestry",
  "Vaccine distribution",
  "Veteran housing",
  "Volunteer mobilization",
  "Waste-to-energy",
  "Water access",
  "Wetland conservation",
  "Wildfire prevention",
  "Women's shelters",
  "Workplace safety",
  "Youth advocacy",
  "Youth leadership",
  "Zoos and aquariums",
];
  QuestionOne({super.key});

  @override
  State<QuestionOne> createState() {
    return _QuestionOneState();
  }
}

class _QuestionOneState extends State<QuestionOne> {
  late List<String> nonprofits;
    

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_textUpdate);

    nonprofits = List.from(widget.nonprofits);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  void _textUpdate() {
  final text = myController.text.trim();
  setState(() {
    if (text.isEmpty) {
      nonprofits = List.from(widget.nonprofits); // Original list
    } else {
      nonprofits = widget.nonprofits
          .where((nonprofit) => nonprofit.toLowerCase().startsWith(text.toLowerCase()))
          .toList();
      // If the text is not in the nonprofits list, add i
      if (!nonprofits.any((nonprofit) => nonprofit.toLowerCase() == text.toLowerCase())) {
        nonprofits.add(text);
      }
    }
  });
}


  void _changeText(text) {
    final _newValue = text;
    myController.value = TextEditingValue(
      text: _newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: _newValue.length),
      ),
    );
  }

  void _nextPage() {
    widget.responses.clear();
    widget.responses.add(myController.text);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => QuestionTwo(responses: widget.responses)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 30,
                right: 30,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                QuestionTwo(responses: widget.responses)));
                  },
                  child: const Text(
                    "Skip",
                    style:
                        TextStyle(fontSize: 20, color: const Color(0xFF7F9289)),
                  ),
                )),
            Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.85,
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        "What does your non-profit do?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: TextField(
                        controller: myController,
                        decoration: const InputDecoration(
                          hintText: 'Search categories by first letter',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Expanded(
                      child: listNonprofits(context, nonprofits, _changeText),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFF7F9289),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(250, 60),
                      ),
                      onPressed: myController.text.isEmpty ? null : _nextPage,
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget listNonprofits(
    BuildContext context, List<String> nonprofits, changeText) {
  return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: nonprofits.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          child: Center(
              child: ListTile(
            title: Text(nonprofits[index]),
            onTap: () {
              changeText(nonprofits[index]);
            },
          )),
        );
      });
}
