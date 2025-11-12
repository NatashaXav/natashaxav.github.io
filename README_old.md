# Natasha Xavier - Professional Portfolio Website

> Marketing & HR Professional | Strategic Marketing Leader | Talent Development Specialist

[![Live Demo](https://img.shields.io/badge/Live-Demo-brightgreen)](https://natashaxavier.github.io/natasha-xavier-portfolio)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/natashaxavier)

## 🌟 Overview

A world-class professional portfolio website showcasing marketing and HR expertise through an engaging, modern, and fully responsive design. Built with vanilla HTML, CSS, and JavaScript, featuring dark mode, interactive animations, and comprehensive project case studies.

## ✨ Features

### Design & UX
- **🌓 Dark Mode Toggle**: Seamless light/dark theme switching with persistent preference
- **📱 Fully Responsive**: Optimized for desktop, tablet, and mobile devices
- **🎨 Modern UI**: Clean, professional design with smooth animations and transitions
- **♿ Accessible**: WCAG-compliant with proper ARIA labels and keyboard navigation

### Interactive Elements
- **⌨️ Typing Animation**: Dynamic hero section with rotating role titles
- **📊 Animated Statistics**: Counter animations triggered on scroll
- **🎯 Smooth Scroll**: Seamless navigation with active section highlighting
- **🎨 Particle Effects**: Subtle animated background for visual interest
- **📈 Skill Bars**: Animated progress bars showing proficiency levels

### Content Sections
- **Hero Section**: Engaging introduction with call-to-action buttons
- **About Me**: Comprehensive professional overview with statistics
- **Work Experience**: Timeline-based experience showcase with detailed achievements
- **Education**: Academic background and relevant coursework
- **Skills**: Categorized skills with visual proficiency indicators
- **Projects**: 5 detailed project case studies with full breakdowns
- **Contact**: Functional contact form with validation

## 🚀 Quick Start

### View Locally

1. **Clone the repository**
```bash
git clone https://github.com/natashaxav/natasha-xavier-portfolio.git
cd natasha-xavier-portfolio
```

2. **Open in browser**
```bash
# On macOS
open index.html

# On Linux
xdg-open index.html

# On Windows
start index.html
```

Or use a local server:
```bash
# Using Python 3
python -m http.server 8000

# Using Node.js
npx http-server

# Then visit http://localhost:8000
```

### Deploy to GitHub Pages

1. **Create GitHub Repository**
```bash
gh repo create natasha-xavier-portfolio --public
```

2. **Deploy using the master script**
```bash
./deploy-all.sh --deploy
```

3. **Enable GitHub Pages**
   - Go to repository Settings → Pages
   - Select "Deploy from main branch"
   - Your site will be live at `https://[username].github.io/natasha-xavier-portfolio`

## 📁 Project Structure

```
natasha-xavier-portfolio/
├── index.html                      # Main website entry point
├── assets/
│   ├── css/
│   │   └── style.css              # Complete styling with dark mode
│   ├── js/
│   │   └── script.js              # Interactive features and animations
│   └── images/                    # Image assets (add your photos here)
├── projects/
│   ├── project1.html              # Social Media Engagement Campaign
│   ├── project2.html              # SEO & Lead Generation Campaign
│   ├── project3.html              # HR Tech Hub Implementation
│   ├── project4.html              # Brand Content Strategy
│   └── project5.html              # Analytics & Insights Framework
├── project-repos/                 # Detailed project documentation
│   ├── social-media-engagement/
│   ├── seo-lead-generation/
│   ├── hr-tech-hub/
│   ├── brand-content-strategy/
│   └── analytics-insights/
├── INTERVIEW_PREP_GUIDE.md        # Comprehensive interview preparation
├── deploy-all.sh                  # Master deployment script
└── README.md                      # This file
```

## 🎨 Customization Guide

### Adding Your Photo

Replace the placeholder images:
```html
<!-- In index.html, find and update: -->
<div class="image-placeholder">
    <!-- Replace with: -->
    <img src="assets/images/profile-photo.jpg" alt="Natasha Xavier">
</div>
```

### Updating Contact Information

Edit the contact section in `index.html`:
```html
<a href="mailto:your-email@example.com">your-email@example.com</a>
<a href="tel:+1234567890">+1 (234) 567-890</a>
```

### Modifying Colors

Update CSS variables in `assets/css/style.css`:
```css
:root {
    --primary-color: #4F46E5;      /* Main brand color */
    --secondary-color: #EC4899;    /* Accent color */
    --accent-color: #10B981;       /* Success/highlight color */
}
```

### Adding Projects

1. Create new project HTML file in `projects/`
2. Update the projects section in `index.html`
3. Add project to the grid:
```html
<div class="project-card">
    <div class="project-image">
        <div class="project-overlay">
            <a href="projects/your-project.html" class="btn btn-project">View Details</a>
        </div>
    </div>
    <div class="project-content">
        <h3 class="project-title">Your Project Title</h3>
        <p class="project-description">Project description...</p>
    </div>
</div>
```

## 🛠️ Technologies Used

- **HTML5**: Semantic markup structure
- **CSS3**: Modern styling with CSS Grid, Flexbox, and custom properties
- **JavaScript (ES6+)**: Interactive features and animations
- **Font Awesome**: Icon library
- **Google Fonts**: Typography (Inter font family)

## 📊 Projects Showcase

### 1. Social Media Engagement Campaign
**Company**: Pictures in Motion | **Location**: London, UK
**Key Results**: 25% engagement increase, 35% interaction growth, 20% follower growth

Comprehensive social media strategy driving authentic audience growth for entertainment production company through data-driven content optimization and cross-functional collaboration.

### 2. SEO & Lead Generation Campaign
**Company**: Grey Apple Advertising | **Location**: Remote
**Key Results**: 450+ leads generated, 12% organic traffic increase, 15% sales growth

Multi-channel marketing initiative combining SEO optimization, event marketing, and CRM campaigns to drive qualified lead generation and revenue growth.

### 3. HR Tech Hub Implementation
**Company**: Walmart Global Tech | **Location**: Bangalore, India
**Key Results**: 23% time-to-hire reduction, 15% engagement improvement, 2,000+ employees impacted

Large-scale HR technology implementation streamlining recruitment processes and deploying HRIS platform across international operations.

### 4. Brand Content Strategy
**Company**: Grey Apple Advertising | **Location**: Remote
**Key Results**: 15% brand sentiment improvement, 20% customer satisfaction boost

Integrated content strategy spanning digital and out-of-home channels ensuring brand consistency and improved customer perception.

### 5. Analytics & Insights Framework
**Companies**: Pictures in Motion & Grey Apple Advertising
**Key Results**: Data-driven decision culture, profitability optimization

Comprehensive analytics implementation providing actionable insights through multi-source data integration and systematic reporting frameworks.

## 📚 Additional Resources

### Interview Preparation Guide
Comprehensive guide with STAR-technique answers for common marketing and HR interview questions. See `INTERVIEW_PREP_GUIDE.md`.

### Project Case Studies
Detailed Medium-style case studies for each project in `project-repos/[project-name]/docs/CASE_STUDY.md`.

## 🤝 Contact

**Natasha Xavier**
Marketing & HR Professional

- 📧 Email: natashaxavier512@gmail.com
- 📱 Phone: +44 7984 749460
- 🌍 Location: London, United Kingdom
- 💼 LinkedIn: [linkedin.com/in/natashaxavier](https://linkedin.com/in/natashaxavier)
- 🐙 GitHub: [github.com/natashaxav](https://github.com/natashaxav)

## 📄 License

This project is open source and available for personal use. Please credit Natasha Xavier when using this template.

## 🙏 Acknowledgments

- Built with attention to detail and user experience
- Designed to showcase professional achievements authentically
- Optimized for both recruiters and hiring managers

---

**Version**: 1.0.0
**Last Updated**: November 2024
**Status**: Active & Maintained

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
