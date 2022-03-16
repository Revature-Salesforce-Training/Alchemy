
Big Brother Timepieces

Our project was divvied up into several sections. Each person created at least one(1) Lightning Web Component, at least one(1) Aura Component Bundle,
at least one(1) Apex Trigger, at least one(1) Apex Class/Controller, and everyone created 100% coverage Apex tests for their triggers and classes.

We created and hosted a published Digital Experience site on Salesforce; we called it Big Brother Timepieces using the slogan "We're Always Watchin".
We used an Aura component as a layout, and broke it down very granularly for our design process.

Our team decided to have a persistent Header and Nav Bar components, with two(2) "action" containers that would change whats rendered inside of them.
These two active containers are subscribed to a Lightning Message Service to recieve event information, telling them what to render inside.

Our design was a 75% block on the left for less active "browsing", and a 25% block on the right for the more interaction heavy portions.
We decided on this design to keep your browsing in one section, and uninterupted by any actions you might need to take. For example the 
main container will show the Product Catalogue. Each product has a button to "view Product", which will publish an LMS message. The
Side Bar on the right will get that message, and switch to the product display. This keeps the Product Catalogue visible in the 75% block,
only changing the side bar's content.
