Design:

I apologies that the designs are a bit different to the required spec. I was playing with the UI for fun when I was first given the project, with the intention of changing it once I had a response back from you. But the app took longer than I had expected and I have ran out of time so I’m having to send the app ‘as is’ as I have other plans for the rest of the day.

My thought process with the CollectionViewCell design was that a user will have expected behaviour from a cell which looks like TableViewCell. Additionally with the chevrons, this would have looked odd when viewed on an iPad which has multiple cells per line.
So instead I removed the chevrons and made it look less like a TableViewCell by putting a box round it. This IMO worked well in both iPhone and iPad.

Regarding the Details screen. To me it seemed the summary data displayed on the Trending screen should be duplicated along with additional information requested in the spec.
I’m not 100% pleased with the layout. It looks a bit sparse on an iPad.
I prefer the symbols used in the spec, and how the text looks. In many ways I prefer the large ‘view on GitHub’ button in the spec, however I do find a method to copy a URL handy when I URL is large and ugly and tricky to display.
With a bit more time I would have cleaned the UI up, formatted the date string, added the favourite button in etc

In general I think the simplified UI works well without the segmented control at the top.
Note the tabBar is always present. This is deliberate so that the user always knows where they are and how they can quickly get back to the core functionality.
See here for a detailed explanation of my thought process regarding this…
https://uxplanet.org/tab-bars-are-the-new-hamburger-menus-9138891e98f4

As always there’s improvements to be made given enough time, the occasional animation here and there greatly improves the sleekness of an app IMO, that’s always my favourite bit, but sadly it comes last in priorities often :)


Architecture :


I have used Notifications to finish the app off. I usually despise notifications and almost never use them. The original plan was to use Model to send multicast messages to delegates as data changed. instead I have hardcoded the model in places and used notifications due to time constraints.
General architecture is MVVM with TrendingViewModel taking most of the weight in this app, and removes most of the view/viewcontroller related data logic.

TrendingViewModel contains multiple PageArray’s which are custom Array’s. The intention was to have an Array like container that kept additional paging related state information, and if I'm completely honest to also prove that I knew how to use Generics.
However, in hindsight, it would've been better and quicker implemented as a standard array wrapped in an object.

For this project I tied to ditch old Objective C based habits and technologies in favour of more Swifty ones. For instance I have used AFNetworking for years but AlamoFire was built from the ground up in Swift so made the switch to that. As such, I had no previous code or snippets or familiarity I would normally have. AlamoFire came with it’s own set of problems, the imageCache plugin was not compatible with the activity indicator plugin and so I had to quickly make a custom class myself.
The imageCache AlamoFire  plugin also only does in-memory caching, I’d probably go back to using SDWebImage in the future.
I wasted a bit time trying to find a Swifty alternative to CordData, Realm seemed to use @objc a lot, and I never feel comfortable with putting data such as favourites into a basic flat file (or similar) that I can’t easily expand and migrate going forward.
So back to CoreData it was!For now anyway, again time constraints. I’m definitely on the look out for a decent Swifty alternative to persistence.
I used to use MagicalRecord which is an ActiveRecord style layer on top of CoreData to simplify the awful API.
I wrote the CoreRecord class instead, which provides 90% of the functionality I used in MagicalRecord with 0.1% of the code base which I’m pretty pleased with. This class also removes the CoreData setup code that would usually clog up the AppDelegate class in Apples standard implementation. Uses Generics too :)


I’m not 100% happy with the app. Architecturally it’s definitely lacking and that’s now my number one priority as areas to improve and I really took forward to reading up on MVP. I would have definitely liked to have finished the app, the source is littered with TODO’s. I’ll probably end up finishing it off and giving it a proper refactoring regardless of whether I get this contract or not, just for fun.


