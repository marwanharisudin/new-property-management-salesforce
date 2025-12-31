Salesforce Property Inspection Dashboard

Overview
This repository contains a Salesforce implementation for a Property Inspection Dashboard using Apex, Lightning Web Components (LWC), and Flow.
The solution is designed to display inspection-related data on the Account page and automate business logic using Salesforce declarative and programmatic tools.

Setup Instructions
1. Clone Repository
git clone <repository-url>

2. Deploy Metadata
- Deploy all metadata using Salesforce CLI:
    sfdx force:source:deploy -p force-app
- Or deploy using Change Sets if preferred.

3. Assign Permissions
- Ensure the running user has access to:
  - Custom Objects
  - Custom Fields
  - Apex Classes
  - Flow
  - LWC Component

4. Activate Flow
- Navigate to Setup → Flows
- Activate the provided Flow after deployment

5. Add LWC to Account Page
- Open Lightning App Builder
- Edit the Account Record Page
- Drag and drop the LWC component
- Save & Activate the page

Approach to the Requirements
Backend (Apex)

- PropertyInspectionDashboardController
  - Acts as the main controller for the LWC
  - Retrieves and aggregates inspection-related data
  - Optimized SOQL usage to avoid governor limits
- PropertyInspectionHandler
  - Handles business logic related to inspections
  - Keeps logic separated for better maintainability and testability

Frontend (LWC)
- Displays inspection data directly on the Account record page
- Uses Apex controller methods via @wire / imperative calls
- Designed to be reusable and lightweight

Automation (Flow)
- Used for process automation related to inspection data
- Complements Apex logic where declarative automation is more suitable

Assumptions Made
- Each inspection record is related to an Account
- Users accessing the dashboard already have appropriate object permissions
- The solution is designed for Lightning Experience
- Data volume is within reasonable Salesforce governor limits

Known Limitations
- The dashboard focuses on Account-level inspection data only
- No external system integration included
- UI customization is limited to standard Lightning styling
- Flow logic assumes correct data input and relationships

Test Execution Results
- Apex Class PropertyInspectionDashboardController with Code Coverage 100%
- Apex Class PropertyInspectionHandler	with Code Coverage 97%

Screenshots & Evidence
All screenshots have been compiled into a single PDF document for easier review:
- `/screenshots/Marwan Harisudin - Screenshot Evidence.pdf`

Repository Structure (Summary)
force-app/
 └── main/
     └── default/
         ├── classes/
         ├── lwc/
         ├── flows/
         ├── objects/
         ├── validationRules/         
screenshots/
 ├── flow-diagram/
 ├── lwc-account-page/
 ├── custom-object-fields/
 └── test-results/
 
Evidence Checklist
✔ Apex class source code
✔ Apex test class source code with coverage results
✔ LWC component files (HTML, JS, CSS, XML)
✔ Flow screenshots
✔ Custom object & field definitions
✔ Validation rule and formula field configurations
✔ Screenshots showing working functionality
