# Copia

A new Flutter project, Changes your experience with books!

## Getting Started
Copia is an application used to store PDFs as books. 
![owl_iphonesespacegrey_portrait](https://user-images.githubusercontent.com/50237142/81900072-70f95480-95bc-11ea-8822-d02a31f00855.png)

### It allows you to :
- Choose whatever your pdf is.
- Assign a title and a descriptive image to your pdf. 
- Add bookmarks to pages in your pdf.
- You can add an audio with your pdf to listen while you're reading.
- You can add document (doc , docx) to your pdf to view while reading.
- You can add custom notes to every page in your pdf.
- Also , gives you statistics of how many hours have you read a certain PDF , when was the last time you opened it and when did you create the file.
- No internet access needed , all stored locally.

## Release dates & notes : 

 ## 2 June 2020 
- Copia 1.0.0 was sent to publication in google play store. 
- The initial release contained all of the first 12 tasks.
- Verified by play store on **5/6/2020**.
- The next update estimated to be after two months.

## Project technical structures : 
- Uses **Hive** as local storage database.
- Uses **flutter_sound** as the flutter audio player.
- Uses **Provider** as state management solution.
- Uses **SharedPerefences** as key-value holder. (Can use Hive) 
- Uses **GoogleFonts** for Font UI perefrences. 
- Uses **native_pdf_view** as a PDF renderer library.

## Tasks : 
- [x] App Logo & Splash Screen
- [x] Intro screen
- [x] Audio Screen
- [x] Document Screen
- [x] Save Screenshot to gallery.
- [x] Share a screenshot of the current page
- [x] Search PDF Screen
- [x] Add notes screen
- [x] Bookmarks Screen
- [x] Statistics Screen
- [x] Share PDF file  
- [x] Complete UI refactor.
## Postponed tasks after beta production: 
- [ ] Handling all errors & exceptions with dialogs. (For User experience)
- [ ] Complete Code Refactor
- [ ] Ensure Clean code
- [ ] Complete API documentation.
- [xx] Doc Text to Speech *Postponed to next update*


### Intro Screen 

<img width="404" alt="Screen Shot 2020-05-15 at 1 37 25 AM" src="https://user-images.githubusercontent.com/50237142/81996196-bfeeca80-964c-11ea-8d06-7ee87ed924c9.png">

The user enters the application , then will find 4 screens known as ["On-boarding screens"](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/IntroScreen/intro_screen.dart#L14)

- This will briefly describe the copia application.
- Along with beautiful svg assets.
- The user can [skip](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/IntroScreen/intro_screen.dart#L73) the whole intro and jump to the controller screen.
- Using [SharedPrefences](https://github.com/MeitanteiAshour/Copia/blob/master/lib/main.dart#L27) to identify if this the user's first time to enter the application.
- The next screen is the controller screen which controls the home screen.

### Controller Screen 
#### Home screen
![copiaHomeScreen](https://user-images.githubusercontent.com/50237142/82972025-59ff2d00-9fd4-11ea-9ced-a6ddbc771f49.png)

When the user opens the home screen page , A list of 5 books appears in the [*Your books* part](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/HomeScreen/home.dart#L18).

  ![copiaAddPdf](https://user-images.githubusercontent.com/50237142/82972238-d560de80-9fd4-11ea-8af4-4449f3875303.png)
- The user could do 3 commands : 
  - Add new PDF
  - The user adds a **PDF title** , the pdf source & PDF thumbnail representing the PDF.   
  - View All PDFs
  - View the last opened PDF
  

### PDF Screen 
<img width="358" alt="Screen Shot 2020-05-14 at 8 24 29 AM" src="https://user-images.githubusercontent.com/50237142/81900092-7ce51680-95bc-11ea-9487-ab17311be7a4.png">

- The [Floating action button (owl icon)](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L144) (bottom-right) is the main PDF icon manager , it controls the PDF screen features
- It expands and minimizes once clicked on.
- It dissapears once clicked on the PDF itself. (to give the reader comfort time while reading) 

![copiaPdfMenu](https://user-images.githubusercontent.com/50237142/82972390-38eb0c00-9fd5-11ea-9cb6-ff3176d45ae4.png)

### Owl Fab components : 
#### Bookmarks (Heart icon) 
- The user can [bookmark](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L159) a certain page in the PDF. It has 2 expected behaviours : 
- When clicked at first (assuming that the page isn't bookmarked) , the heart turns to red , and the page number is updated in the database. 
- When clicked (assuming that the page is already bookmarked) , the heart returns to the original color , and the page number is removed from the database.

#### Bookmarks List 
- The [bookmarks list](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L160) contains a list with the bookmarked pages in the PDF , if there's no bookmarked page , then it displays nothing rather than "You don't have any bookmarked pages! ". 
if there's items , then it displays the list of items. on clicking on *each item* the PDF view animates forward to the selected bookmarked page. 

#### PDF audio
- The user can choose any [audio](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L161) they want to play along the PDF while reading. 
- At first the audio is null (assuming that the user didn't add any audio yet) , then when the user adds a new audio , the audio bar appears in the bottom navigation bar of PDFScreen.
- The user can **Play** ,**Pause** & **Seek** to a certain duration through the audio.

##### Use case : 
- Say that there's a PDF about technological topic i.e. *"Scrum vs Kanban"* , The user would like to add an audio of technical debate between Kanban and Scrum while reading the PDF. 

#### Orientation 
- The user can decide whether the PDF [orientation](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L162) is vertical or horizontal.

#### Add notes 
- The user can add a [note](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L176) per page (similar to bookmarks).
##### The note structure is as follows : 
- The notes are *Map<int,String>* where the *int* is the currentPage number (The page where the note is written into) , and the String is the note content. 
- If the notes are null (assuming that this is the first time for the user to open application & didn't add yet any notes) then a TextField appears to add a new note to the page.

#### PdfScreenshot
- The user can [save the current page](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L177) to gallery.
- All pictures saved are under a folder named "Copia".

#### Pdf Document
- Sometimes , Users want an [alternative document](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L178) to the PDF file , or a supporting document file.
- Each Pdf can add one document only attached to it. 
- The user can add a certain document of **doc,docx** extenstion. 
- The user then can open the document using a helper application such as *Word , google docs or any other application*.
- The user can replace , delete or open the document wherever they want.

#### Share PDF page 
- Similar to PdfScreenshot , The user can [share the pdf page](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/PDFScreen/pdfscreen.dart#L179) with other users through the social media apps or email or any other media. 
- The outputed picture is a screenshot of the current Page with copia logo appearing top-left the screen. 
- A companion message is delivered with the outputted picture.

## Search PDF page 

![copiaSearchScreen](https://user-images.githubusercontent.com/50237142/83204098-43c7ad00-a14b-11ea-8442-32eef7c13e2f.png)

- The user can view all pdfs they entered in the Copia application.
- The user has 3 options in this page : 
  - *Search*
  - *Delete PDF*
  - *Share PDF*
  
 ![searchscreen](https://user-images.githubusercontent.com/50237142/83204100-44f8da00-a14b-11ea-9be1-736803657790.png)

- The user can [search](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/AllPdfs/all_pdfs.dart#L19) whatever terminlogy they want , they can search for a specific pdfTitle , if title isn't found then searches within the filename basename (path).

- Also the user can delete the PDF permenantly or share it with other users on social media.

## Statistics Screen 

![statsScreen](https://user-images.githubusercontent.com/50237142/83333619-bc408200-a2a1-11ea-8cfe-e33ebf21124e.png)

- The user could see their reading statistics through the Statistics screen. 

### The Statistics screen structure is as follows : 

There are two types of [statistics](https://github.com/MeitanteiAshour/Copia/blob/master/lib/Screens/StatsScreen/stats_screen.dart#L7) : 

**Statistics for every PDF. (Specific Statistics)**

Which shows :
- Last PDF opened.
- Date of creation of every PDF.
- How much hours , minutes did the reader read a specific PDF
- Most opened PDF.
- Total bookmarks of the PDF.

**Statistics for all PDFs (General Statistics)**

- Number of PDfs the user has.
- Total hours spent on the application.
- Total audio files on the application. 
- Total document files on the application.
- Total pages bookmarked in the application. 

Also , all above statistics are supported by different kind of charts .

## Upcoming features : 
The Upcoming features will be divided to certain Patches during a 9 months period 

**Overall Patches : **

- [ ] Connect Copia to cloud database. 
- [ ] The user could add an audio to every page. 
- [ ] A marker to mark certain parts in the page.
- [ ] Changes in UI.
- [ ] Adding document for every page.
- [ ] Document text to speech.
- [ ] The user could share their stats on social media platforms.
- [ ] Adding reading streaks (for concecutive days) with trophies.
- [ ] Adding a detailed daily statistics about time and pages read.
- [ ] Make Copia app an open PDF file suggestion.
- [ ] Implementing night mode.
- [ ] Add drawing pages (Can draw or write whatever the user wants) for every PDF.

## Far upcoming features :
- [ ] Deploy IOS version.

#### Continuous development Strategy : 
- Adding new brochures , Posters & fixing bugs.
- Running an online survey to see what to add next to the application.

## Patch notes 1.0.1+2 :

**Developed at two stages :**

### First stage : 
- [x] Changes in UI.
*Changes to Neumorphic design*
- [x] Bug fixes.

**Bugs at first release:** 

**Critical bugs**
- Audio dissapears permenantly.
- The bookmarked page dissappears from the list (in DB) randomly.

### Second stage :
July :
- [ ] A marker to mark certain parts in the page.
- [x] Implementing night mode. *Implemented in the first update with neumorphic design)
- [ ] Implementing light mode.
- [ ] Document text to speech.

## Patch notes 1.0.2+3 : 
- [ ] Adding reading streaks (for concecutive days) with trophies.
- [ ] Adding a detailed daily statistics about time and pages read.
- [ ] Bug fixes

## Patch notes 1.1.0 :
- [ ] Make Copia app an open PDF file suggestion.
- [ ] Add drawing pages (Can draw or write whatever the user wants) for every PDF.
- [ ] The user could add an audio to every page. 
- [ ] Bug fixes.

## Patch notes 2.0 : 
- [ ] Connect Copia to cloud database. 
