# Mac Catalyst Recipes App

A **Mac Catalyst** application built with **Swift**, allowing users to create, edit, and manage their favorite recipes across **macOS, iPadOS, and iOS**. Originally inspired by an **Apple Developer tutorial**, this project evolved into a fully functional **CRUD-based** recipes app with persistent data storage.

## Features
### Core Functionality:
- **Browse Recipes** – View a list of saved recipes with ingredients and instructions.
- **Create, Edit, Delete** – Add new recipes, modify existing ones, and remove unwanted ones.
- **Search & Filter** – Quickly find recipes using keyword search.
- **Image Support** – Add photos to recipes for better visual representation.
- **Persistent Data** – Recipes remain saved even after closing the app (using **Core Data**).
  
### UI & User Experience:
- **Dark Mode Support** – Seamlessly adapts to macOS and iOS dark mode.
- **Multi-Device Compatibility** – Runs on **macOS, iPadOS, and iOS** with a unified UI.
- **Adaptive Layout** – Responsive design with **Auto Layout** to fit different screen sizes.
- **Smooth Animations** – Uses UIKit animations for better user experience.

### Integration & Performance:
- **Built with Mac Catalyst** – A fully functional macOS app derived from iPadOS.
- **Optimized for Performance** – Uses lightweight data models and efficient queries.
- **SwiftLint Used** – Maintains clean and readable Swift code.


## Technologies Used
| Component         | Technology |
|------------------|------------|
| **Language**     | Swift (UIKit) |
| **Framework**    | Mac Catalyst |
| **Data Storage** | Core Data |
| **UI Components** | SwiftUI & Storyboards |
| **Development Tool** | Xcode |
| **Version Control** | Git & GitHub |



## Installation & Setup
Follow these steps to set up and run the app on your Mac or iPad:

### Clone the Repository
```sh
git clone https://github.com/batyrrasulov/mac-catalyst-recipes-app.git
cd mac-catalyst-recipes-app
```

### Open in Xcode
- Open the `.xcodeproj` file in Xcode.
- Ensure **Mac Catalyst** is enabled in **Project Settings**.

### Build & Run
- Select the target device: **Mac, iPad, or iPhone**.
- Click **Run** in Xcode to launch the app.


## How It Works
### **Data Management (Core Data)**
- Recipes are stored in a **Core Data model**, ensuring persistent storage.
- When a recipe is **added, edited, or deleted**, changes are saved in the local database.
- Uses **NSFetchedResultsController** for real-time UI updates.

### **Recipe Display & Search**
- Recipes are displayed in a **UITableViewController** with sections for categories.
- Search functionality filters recipes dynamically as users type.

### **Multi-Device Support**
- Uses **Mac Catalyst** to run the same codebase on macOS, iPadOS, and iOS.
- **Auto Layout & Stack Views** ensure a responsive UI across different devices.


## Challenges & Solutions
### **Challenge:** Persistent Data Storage
**Issue:** Ensuring that recipes remain saved after closing the app.  
**Solution:** Implemented **Core Data** with an `NSPersistentContainer` to store and retrieve recipes efficiently.

### **Challenge:** UI Adaptability Across Devices
**Issue:** Maintaining a clean UI for different screen sizes.  
**Solution:** Used **Auto Layout**, Stack Views, and adaptive UI components.

### **Challenge:** Optimizing Performance
**Issue:** Preventing slow UI updates when managing large recipe lists.  
**Solution:** Used **NSFetchedResultsController** to handle updates efficiently.


## Future Improvements
- **iCloud Sync** – Sync recipes across all Apple devices.
- **Advanced Search** – Search by ingredients, categories, and cooking time.
- **Meal Planning** – Add meal scheduling and grocery list features.
- **Voice Commands** – Use **SiriKit** to add and retrieve recipes.
- **Widgets & Shortcuts** – Add iOS/macOS home screen widgets.

## Screenshots & Demo
![Simulator Screenshot - iPhone 16 Pro - 2025-01-18 at 14 19 22](https://github.com/user-attachments/assets/67566e50-e62e-48f8-9090-38f75b127186)

![Simulator Screenshot - iPhone 16 Pro - 2025-01-18 at 14 19 55](https://github.com/user-attachments/assets/1c298c5e-f757-48bf-97f2-17bbbb37b1d2)

<img width="1022" alt="Screenshot 2025-01-18 at 14 23 06" src="https://github.com/user-attachments/assets/5dcb7246-d606-425a-bffd-5a0cdfc05f52" />

**Demo Video:** [Click Here](https://1drv.ms/v/c/b29dbbf12dfc7458/EeuGUJjGRHBAjYDl14lFHlkBx_fW1WcvV1Fakmec41jDPw?e=4fb1CC)
