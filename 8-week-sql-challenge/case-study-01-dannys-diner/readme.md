# 🥢 Case Study #1 - Danny's Diner

Welcome to the first case study from the [8 Week SQL Challenge](https://8weeksqlchallenge.com/case-study-1/) by Danny Ma!

This case explores how SQL can be used to generate business insights for a small Japanese restaurant called **Danny's Diner**. Using basic purchase and membership data, the challenge focuses on answering customer behavior and loyalty questions through SQL analysis.

---

## 🧾 Case Study Summary

**Business Context:**
Danny's Diner is a small restaurant serving sushi, curry, and ramen. Danny wants to understand customer patterns, preferences, and spending behavior to improve the business and enhance a loyalty program.

**You are provided with 3 tables:**

- `sales`: customer orders with product IDs and dates
- `menu`: product ID mapping to item names and prices
- `members`: customer membership start dates

---

## 🧠 Questions Answered

This project includes SQL solutions to all core questions, such as:

- What is the total amount each customer spent at the restaurant?
- How many days has each customer visited the restaurant?
- What was the first item from the menu purchased by each customer?
- What is the most purchased item on the menu?
- Which item was the most popular for each customer?
- Which item was purchased first after becoming a member?
- Which item was purchased just before becoming a member?
- Total items and amount spent before joining the program?
- Points earned using loyalty rules
- Bonus logic involving 2x points in the first week of membership

> Each question is solved using PostgreSQL in the `queries/` folder.
