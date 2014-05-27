# Auto Layout with Interface Builder

You can create constraints with Interface Builder in 3 different ways:

- From the Editor menu
- With the buttons situated at the bottom-right bar
- Ctrl + Drag

Warnings in the constraints are shown as orange color in the T-bars, meaning that the layout it's incompleted or with mistakes.

Xcode creates automatic constraints if you don't set any constraints of your own. In the moment you set one, you must set all the constraints for that view.

### Intrinsic content size

Some views (buttons, labels…) can calculate their size based on their content, avoiding the need to create constraints for that. That is called intrinsic content size.

You can know their size in Interface Builder clicking **Size to Fit Content** from the **Editor** menu.

### Preview

You can see how your final view will be in different layouts selecting the **Assistant editor** and clicking on **Preview** in the jump bar

### Content hugging and Compression resistance priority

When you have a view with intrinsic content size, there are 2 fields to indicate how the constraints will affect the content of that view.

These are **Hugging priority** and **Compression resistance priority**, you can set them from the **Size inspector**.

- Content hugging priority: Priority of the view to adjust to content (avoiding being bigger) if the content is smaller than the view.
- Content compression resistance priority: Priority of the view to avoid reducing his size if the view is smaller than the content.