# Getting Started with Your Portfolio Website

Welcome! This guide will help you get your professional portfolio website up and running.

## 📋 What You've Got

Your portfolio includes:

1. **Main Website** (`index.html`)
   - Hero section with typing animation
   - About section with statistics
   - Work experience timeline
   - Education and certifications
   - Skills showcase with animated bars
   - 5 project cards linking to detailed pages
   - Contact form
   - Dark mode toggle
   - Fully responsive design

2. **5 Detailed Project Pages** (`projects/`)
   - Social Media Engagement Campaign
   - SEO & Lead Generation Campaign
   - HR Tech Hub Implementation
   - Brand Content Strategy
   - Analytics & Insights Framework

3. **Project Documentation** (`project-repos/`)
   - Detailed case studies for each project
   - GitHub-style repository structure
   - Ready to deploy as separate repos

4. **Interview Preparation** (`INTERVIEW_PREP_GUIDE.md`)
   - 14 detailed STAR-technique answers
   - Marketing and HR questions
   - Situational and competency questions
   - Questions to ask interviewers

5. **Deployment Script** (`deploy-all.sh`)
   - One-command deployment to GitHub
   - Automatic repository setup
   - GitHub Pages configuration

## 🚀 Step-by-Step Setup

### Step 1: View Your Website Locally

1. **Open the folder in your file browser**
   ```bash
   cd /Users/rj/Claude_code/natash
   ```

2. **Open `index.html` in your browser**
   - On Mac: Double-click `index.html` or right-click → Open With → Browser
   - Or drag the file into your browser window

3. **Test the features:**
   - Click the moon/sun icon to toggle dark mode
   - Scroll through each section
   - Click on project cards to view detailed pages
   - Try the contact form
   - Test on mobile (use browser dev tools: F12 → Toggle Device Toolbar)

### Step 2: Personalize Your Content

#### Add Your Photo

1. Save your professional photo as `profile.jpg`
2. Place it in `assets/images/` folder (create this folder if it doesn't exist)
3. Update `index.html`:
   - Find `<div class="image-placeholder">`
   - Replace with:
   ```html
   <div class="image-wrapper">
       <img src="assets/images/profile.jpg" alt="Natasha Xavier" class="profile-image">
   </div>
   ```

#### Update Social Links

In `index.html`, find and update:
```html
<a href="https://linkedin.com/in/natashaxavier" target="_blank">
<a href="https://github.com/natashaxav" target="_blank">
```

#### Verify All Information

Check that all content matches your resume:
- ✅ Contact information (phone, email, location)
- ✅ Work experience dates and achievements
- ✅ Education details
- ✅ Skills and tools
- ✅ Project descriptions

### Step 3: Deploy to GitHub

#### Option A: Using the Deployment Script (Recommended)

1. **Install GitHub CLI (if not already installed)**
   ```bash
   # On Mac
   brew install gh

   # On Windows
   winget install GitHub.cli
   ```

2. **Authenticate with GitHub**
   ```bash
   gh auth login
   ```

3. **Create repositories**
   ```bash
   # Create main repository
   gh repo create natasha-xavier-portfolio --public --description "Professional portfolio website"

   # Create project repositories (optional)
   gh repo create social-media-engagement --public
   gh repo create seo-lead-generation --public
   gh repo create hr-tech-hub --public
   gh repo create brand-content-strategy --public
   gh repo create analytics-insights --public
   ```

4. **Deploy everything**
   ```bash
   ./deploy-all.sh --deploy
   ```

#### Option B: Manual GitHub Deployment

1. **Create a new repository on GitHub**
   - Go to https://github.com/new
   - Name: `natasha-xavier-portfolio`
   - Description: "Professional portfolio website"
   - Public repository
   - Don't initialize with README (we already have one)

2. **Push your code**
   ```bash
   cd /Users/rj/Claude_code/natash

   git init
   git add .
   git commit -m "Initial commit: Professional portfolio website"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/natasha-xavier-portfolio.git
   git push -u origin main
   ```

3. **Enable GitHub Pages**
   - Go to your repository on GitHub
   - Click "Settings" → "Pages"
   - Under "Source", select "Deploy from a branch"
   - Select "main" branch and "/ (root)" folder
   - Click "Save"
   - Your site will be live at: `https://YOUR-USERNAME.github.io/natasha-xavier-portfolio`

### Step 4: Share Your Portfolio

Once deployed, share your portfolio:

**On LinkedIn:**
- Update your "Featured" section with the link
- Add it to your profile headline or summary
- Share a post announcing your new portfolio

**On Your Resume:**
- Add the URL at the top with your contact information
- Example: `Portfolio: https://natashaxavier.github.io/natasha-xavier-portfolio`

**In Applications:**
- Include the link in your cover letter
- Mention it in your application emails
- Reference specific projects when relevant

**Via Email:**
```
Subject: Natasha Xavier - Marketing & HR Professional

Hello [Name],

I'm reaching out regarding [opportunity]. I've put together a comprehensive portfolio
showcasing my work in marketing and HR:

https://natashaxavier.github.io/natasha-xavier-portfolio

Key highlights:
• 25% social media engagement increase at Pictures in Motion
• 450+ leads generated through integrated marketing at Grey Apple Advertising
• HRIS implementation impacting 2,000+ employees at Walmart Global Tech

I'd love to discuss how my experience could contribute to [company/role].

Best regards,
Natasha Xavier
natashaxavier512@gmail.com | +44 7984 749460
```

## 💡 Tips for Success

### For Job Applications

1. **Customize for Each Role**
   - If applying for marketing roles, emphasize marketing projects first
   - For HR roles, lead with HR achievements
   - Update the hero subtitle to match the role

2. **Track Your Analytics**
   - Use Google Analytics to see who visits
   - Track which projects get the most views
   - Understand what resonates with viewers

3. **Keep It Updated**
   - Add new projects as you complete them
   - Update metrics as they improve
   - Refresh testimonials and achievements

### Interview Preparation

1. **Study Your Projects**
   - Review each case study thoroughly
   - Be ready to discuss challenges, actions, and results
   - Practice telling stories using STAR technique

2. **Use the Interview Guide**
   - Review `INTERVIEW_PREP_GUIDE.md` before interviews
   - Customize examples for specific company/role
   - Practice out loud, not just reading

3. **Bring Your Portfolio**
   - Have it open on your laptop during video interviews
   - Screen share specific projects when relevant
   - Send the link in follow-up emails

### Maintenance

**Monthly:**
- Review and update metrics if they've improved
- Check all links are working
- Test website on different devices
- Update with any new achievements

**Quarterly:**
- Add new projects or case studies
- Refresh testimonials if you have new ones
- Update skills based on what you're learning
- Review and improve content based on feedback

**Annually:**
- Complete design refresh if needed
- Update your professional photo
- Review entire site for outdated information
- Consider adding new features or sections

## 🆘 Troubleshooting

### Website Doesn't Load

**Problem**: Opening `index.html` shows broken styles
**Solution**: Make sure folder structure is intact:
```
natash/
├── index.html
├── assets/
│   ├── css/style.css
│   └── js/script.js
└── projects/ (project files)
```

### Dark Mode Doesn't Work

**Problem**: Theme toggle button does nothing
**Solution**: Check browser console (F12) for JavaScript errors. Ensure `assets/js/script.js` is loading.

### GitHub Pages Shows 404

**Problem**: GitHub Pages URL returns 404 error
**Solution**:
1. Check Settings → Pages shows "Your site is published"
2. Wait 5-10 minutes for first deployment
3. Ensure `index.html` is in the root directory
4. Try accessing with `/index.html` at the end of URL

### Mobile Layout Looks Broken

**Problem**: Site doesn't respond properly on mobile
**Solution**: Ensure viewport meta tag is in `<head>`:
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### Contact Form Doesn't Work

**Note**: The contact form currently only shows a success message. To make it functional:
1. Use a service like Formspree: https://formspree.io
2. Or set up backend with services like Netlify Forms
3. Or use a form service like FormSubmit

## 📞 Need Help?

### Common Questions

**Q: Can I use this for other purposes beyond job hunting?**
A: Yes! This portfolio is also great for:
- Freelance client acquisition
- Personal branding
- Showcasing work to colleagues
- Building your professional online presence

**Q: How do I add more projects?**
A:
1. Create new HTML file in `projects/` folder
2. Copy an existing project HTML as template
3. Update content with new project details
4. Add project card to `index.html` projects section

**Q: Can I change the color scheme?**
A: Yes! Edit CSS variables in `assets/css/style.css`:
```css
:root {
    --primary-color: #YourColor;
    --secondary-color: #YourColor;
}
```

**Q: How do I add Google Analytics?**
A: Add this to `<head>` section of `index.html`:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=YOUR-GA-ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'YOUR-GA-ID');
</script>
```

## 🎉 You're Ready!

Your professional portfolio website is complete and ready to help you land your next opportunity. Remember:

1. ✅ Review all content for accuracy
2. ✅ Add your professional photo
3. ✅ Test on different devices
4. ✅ Deploy to GitHub Pages
5. ✅ Share widely on LinkedIn and in applications
6. ✅ Use the interview guide to prepare
7. ✅ Keep your portfolio updated

**Good luck with your job search!** 🚀

---

**Questions or need modifications?**
Feel free to customize any part of this portfolio to match your personal brand and career goals.

The website is built with standard HTML, CSS, and JavaScript, making it easy to modify and maintain.

