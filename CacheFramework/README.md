# Company iOS home assignment

Your task is to contribute to a framework called **Cache**. It's a module built for fetching data from a `URL` and cache it.

It's a really simple framework that currently exposes an `ImageCache` class that lets you fetch images from a `URL`, and it will automatically cache them in memory.

This project contains the framework **Cache** and a very simple app that integrates with the **Cache**.
You do not have to refactor the sample app - only change what you need in order to account for any changes you do to the **Cache** framework.

## Todo list (MVP)
- [ ] **Disk cache**: Add support for caching to a file on disk. API access must be asynchronous and thread safe. Cache eviction is optional.
- [ ] **Generic**: Add support for fetching and caching more than just images.
- [ ] **Support value types**: The framework should support caching of value types.
- [ ] **Cancellation**: The app has a bug where images are shown out of order and in the wrong cells. To fix this - implement cancellation logic.
- [ ] **Error handling**: Make sure the framework handles errors in a nice way (instead of ignoring them)

## Optional todo list
- [ ] **Image scaling**: Images can be quite big - we've provided a scaling function. Add support for storing scaled images.
- [ ] **Configurable cache**: Some objects might not make sense to cache on disk, design the framework so that you can easily compose a caching hierarchy logic to suit the needs of the integrator.

## Hints for the code review (what we'll be looking for)

- **Architecture** Write generic, simple, extendable and composable code.
- **API Design** Make sure the framework is easy for an integrator to use and understand, just by looking at the public api.

## Requirements

- All code should be written in Swift showcasing your knowledge in Swift language and it’s unique features.
- Commit and comment your changes to the local git repro.
- Do not use any third party dependencies aside from Apple's core frameworks.

**Good luck!**
