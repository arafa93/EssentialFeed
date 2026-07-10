EssentialFeed

A feed application built in Swift following Test-Driven Development (TDD), Clean Architecture, and Continuous Integration practices.

Overview

EssentialFeed is a learning project focused on building a production-quality application by applying modern iOS engineering practices.

The project emphasizes:

Test-Driven Development (TDD)

SOLID principles

Clean Architecture

Continuous Integration (GitHub Actions)

Modular design

Dependency Injection

Maintainable and scalable code

Although the project starts as a macOS framework for faster feedback during development, it will later evolve into a complete iOS application.

Features

Feed loading

Remote data fetching

Local caching

Offline support

Image loading

Error handling

Unit tests

End-to-end tests

Technologies

Swift

Xcode

XCTest

Git

GitHub Actions

Project Structure

EssentialFeed
├── EssentialFeed
├── EssentialFeedTests
├── EssentialFeedAPIEndToEndTests
├── .github
│   └── workflows
│       └── ci.yml
└── README.md

Continuous Integration

The project uses GitHub Actions to automatically:

Build the project

Execute the test suite

Validate every push and pull request

The workflow configuration can be found at:

.github/workflows/ci.yml

Getting Started

Clone the repository:

git clone <repository-url>

Open the project:

open EssentialFeed.xcodeproj

Run the tests:

xcodebuild clean build test \
  -project EssentialFeed.xcodeproj \
  -scheme CI

Learning Objectives

This repository is intended to practice:

Writing testable code

Incremental software design

Refactoring with confidence

Building maintainable applications

Applying Continuous Integration

License

This project is for educational purposes.
