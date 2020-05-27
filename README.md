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
- Also enforced with TTS (Text to speech) to listen to your doc file.
- You can add custom notes to every page in your pdf.
- Also , gives you statistics of how many hours have you read a certain PDF , when was the last time you opened it and when did you create the file.
- No internet access needed , all stored locally.


## Tasks : 
- [x] Intro screen
- [x] Audio Screen
- [x] Document Screen
- [ ] Doc Text to Speech *Postponed to next update*
- [ ] Search PDF Screen
- [ ] Add notes screen
- [ ] Statistics Screen
- [x] Bookmarks Screen
- [ ] Upload PDF Screen
- [ ] Complete Code Refactor
- [ ] Ensure Clean code
- [x] App Logo & Splash Screen
- [ ] Share PDF 
- [x] Save Screenshot to gallery
- [ ] Handling all errors , exceptions with dialogs. (For User experience)
- [x] Share a screenshot of the current page



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

- The user could do 3 commands : 
  -- Add new PDF
  ![copiaAddPdf](https://user-images.githubusercontent.com/50237142/82972238-d560de80-9fd4-11ea-8af4-4449f3875303.png)
- The user adds a **PDF title** , the pdf source & PDF thumbnail representing the PDF. 
  
  -- View All PDFs
  -- View the last opened PDF
  
### Search Screen 

![copiaSearchScreen](https://user-images.githubusercontent.com/50237142/82972306-07724080-9fd5-11ea-8dd6-bf8b36c740b5.png)

- When the user views all PDFs listed in the local storage , they can search for a specific pdfTitle , if title isn't found then searches within the filename basename (path).

### PDF Screen 
<img width="358" alt="Screen Shot 2020-05-14 at 8 24 29 AM" src="https://user-images.githubusercontent.com/50237142/81900092-7ce51680-95bc-11ea-9487-ab17311be7a4.png">

![copiaPdfMenu](https://user-images.githubusercontent.com/50237142/82972390-38eb0c00-9fd5-11ea-9cb6-ff3176d45ae4.png)

#### Upcoming features : 
- Connect it to cloud database. 
- The user could add an audio to every page. 
- A marker to mark certain parts in the page.
- Changes in UI.
- Adding document for every page.
- Document text to speech.
- Adding new brochures , Posters and fixing bugs.
