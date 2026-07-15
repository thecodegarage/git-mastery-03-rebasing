#!/bin/bash

# build-history.sh
# Creates practice history for Git rebasing exercises
# Simulates a blog platform project with multiple developers and feature branches

set -e  # Exit on error

echo "🚀 Building Git history for rebasing practice..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Always clean up any existing feature branches first (even if src/ doesn't exist)
echo -e "${BLUE}🧹 Cleaning up any existing feature branches...${NC}"
for branch in feature/posts-ui feature/comments-system feature/auth-system feature/posts-api feature/complex-changes feature/needs-cleanup feature/in-progress feature/search-improvements feature/rich-text-editor feature/markdown-support feature/social-features feature/performance; do
    git branch -D "$branch" 2>/dev/null || true
done

# Check if src/ directory already exists
if [ -d "src" ]; then
    echo -e "${YELLOW}⚠️  Warning: src/ directory already exists${NC}"
    read -p "Delete and rebuild? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi
    echo -e "${BLUE}🧹 Cleaning up existing practice environment...${NC}"
    # Reset to origin/master (always clean - practice commits never pushed to remote)
    git reset --hard origin/master 2>/dev/null || git reset --hard HEAD~50 2>/dev/null || true
    rm -rf src/
    # Clean up any existing branches
    git branch | grep -v "^\*" | grep -v "master" | grep -v "main" | xargs -r git branch -D 2>/dev/null || true
    echo -e "${GREEN}✅ Cleanup complete${NC}"
    echo ""
fi

echo -e "${BLUE}📁 Creating project structure...${NC}"

# Create directory structure
mkdir -p src

# Developer information
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

# Commit 1: Initial blog structure
export GIT_AUTHOR_DATE="2024-01-15T09:00:00"
export GIT_COMMITTER_DATE="2024-01-15T09:00:00"
cat > src/blog.js << 'EOF'
// Blog Platform - Main Module
// Manages core blog functionality

class BlogPlatform {
    constructor() {
        this.posts = [];
        this.authors = new Map();
    }

    initialize() {
        console.log('Blog platform initialized');
        this.loadPosts();
    }

    loadPosts() {
        // Load posts from database
        console.log('Loading posts...');
    }
}

module.exports = BlogPlatform;
EOF
git add src/blog.js
git commit -m "Initial blog platform structure

Set up main blog module with basic initialization."

# Commit 2: Add posts module
export GIT_AUTHOR_DATE="2024-01-15T10:30:00"
export GIT_COMMITTER_DATE="2024-01-15T10:30:00"
cat > src/posts.js << 'EOF'
// Posts Management Module

class PostManager {
    constructor() {
        this.posts = [];
    }

    createPost(title, content, authorId) {
        const post = {
            id: this.generateId(),
            title,
            content,
            authorId,
            createdAt: new Date()
        };
        this.posts.push(post);
        return post;
    }

    generateId() {
        return Math.random().toString(36).substr(2, 9);
    }

    getAllPosts() {
        return this.posts;
    }
}

module.exports = PostManager;
EOF
git add src/posts.js
git commit -m "Add post management module

Implement create and retrieve functionality."

# Switch developer: Mike Johnson
export GIT_AUTHOR_NAME="Mike Johnson"
export GIT_AUTHOR_EMAIL="mike@example.com"
export GIT_COMMITTER_NAME="Mike Johnson"
export GIT_COMMITTER_EMAIL="mike@example.com"

# Commit 3: Add comments module
export GIT_AUTHOR_DATE="2024-01-16T09:00:00"
export GIT_COMMITTER_DATE="2024-01-16T09:00:00"
cat > src/comments.js << 'EOF'
// Comments System Module

class CommentManager {
    constructor() {
        this.comments = [];
    }

    addComment(postId, userId, text) {
        const comment = {
            id: this.generateId(),
            postId,
            userId,
            text,
            createdAt: new Date()
        };
        this.comments.push(comment);
        return comment;
    }

    getCommentsForPost(postId) {
        return this.comments.filter(c => c.postId === postId);
    }

    generateId() {
        return Math.random().toString(36).substr(2, 9);
    }
}

module.exports = CommentManager;
EOF
git add src/comments.js
git commit -m "Add comments system

Users can now comment on blog posts."

# Commit 4: Add authentication stub
export GIT_AUTHOR_DATE="2024-01-16T11:00:00"
export GIT_COMMITTER_DATE="2024-01-16T11:00:00"
cat > src/auth.js << 'EOF'
// Authentication Module

class AuthManager {
    constructor() {
        this.users = new Map();
        this.sessions = new Map();
    }

    register(username, password) {
        // Simplified registration
        const userId = this.generateUserId();
        this.users.set(userId, { username, password });
        return userId;
    }

    login(username, password) {
        // Simplified login
        for (let [userId, user] of this.users) {
            if (user.username === username && user.password === password) {
                const sessionId = this.createSession(userId);
                return sessionId;
            }
        }
        return null;
    }

    generateUserId() {
        return Math.random().toString(36).substr(2, 9);
    }

    createSession(userId) {
        const sessionId = Math.random().toString(36).substr(2, 16);
        this.sessions.set(sessionId, userId);
        return sessionId;
    }
}

module.exports = AuthManager;
EOF
git add src/auth.js
git commit -m "Add authentication module

Basic user registration and login."

echo -e "${GREEN}✅ Master branch setup complete (4 commits)${NC}"
echo ""

# Create feature branch: posts-ui
echo -e "${BLUE}🌿 Creating feature/posts-ui branch...${NC}"
git checkout -b feature/posts-ui HEAD~2  # Branch from commit 2

# Switch developer: Sarah Chen
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

# Feature commit 1: Add UI module
export GIT_AUTHOR_DATE="2024-01-15T14:00:00"
export GIT_COMMITTER_DATE="2024-01-15T14:00:00"
cat > src/ui.js << 'EOF'
// User Interface Module

class UIManager {
    constructor() {
        this.container = null;
    }

    initialize(containerId) {
        this.container = document.getElementById(containerId);
    }

    renderPosts(posts) {
        const html = posts.map(post => `
            <div class="post">
                <h2>${post.title}</h2>
                <p>${post.content}</p>
            </div>
        `).join('');
        
        this.container.innerHTML = html;
    }
}

module.exports = UIManager;
EOF
git add src/ui.js
git commit -m "Add UI module for post rendering

Basic HTML rendering for blog posts."

# Feature commit 2: Enhance UI
export GIT_AUTHOR_DATE="2024-01-15T16:00:00"
export GIT_COMMITTER_DATE="2024-01-15T16:00:00"
cat > src/ui.js << 'EOF'
// User Interface Module

class UIManager {
    constructor() {
        this.container = null;
    }

    initialize(containerId) {
        this.container = document.getElementById(containerId);
    }

    renderPosts(posts) {
        const html = posts.map(post => this.renderPost(post)).join('');
        this.container.innerHTML = html;
    }

    renderPost(post) {
        return `
            <article class="post">
                <h2 class="post-title">${post.title}</h2>
                <div class="post-meta">
                    <span>By ${post.authorId}</span>
                    <span>${this.formatDate(post.createdAt)}</span>
                </div>
                <div class="post-content">${post.content}</div>
            </article>
        `;
    }

    formatDate(date) {
        return new Date(date).toLocaleDateString();
    }
}

module.exports = UIManager;
EOF
git add src/ui.js
git commit -m "Enhance post rendering with metadata

Display author and date for each post."

echo -e "${GREEN}✅ feature/posts-ui branch created (2 commits)${NC}"

# Back to master
git checkout master

# Create feature branch: comments-system
echo -e "${BLUE}🌿 Creating feature/comments-system branch...${NC}"
git checkout -b feature/comments-system HEAD~1  # Branch from commit 3

# Switch developer: Mike Johnson
export GIT_AUTHOR_NAME="Mike Johnson"
export GIT_AUTHOR_EMAIL="mike@example.com"
export GIT_COMMITTER_NAME="Mike Johnson"
export GIT_COMMITTER_EMAIL="mike@example.com"

# Feature commit 1: Enhance comments
export GIT_AUTHOR_DATE="2024-01-16T14:00:00"
export GIT_COMMITTER_DATE="2024-01-16T14:00:00"
cat > src/comments.js << 'EOF'
// Comments System Module

class CommentManager {
    constructor() {
        this.comments = [];
    }

    addComment(postId, userId, text) {
        if (!text || text.trim().length === 0) {
            throw new Error('Comment text cannot be empty');
        }

        const comment = {
            id: this.generateId(),
            postId,
            userId,
            text: text.trim(),
            createdAt: new Date(),
            likes: 0
        };
        this.comments.push(comment);
        return comment;
    }

    getCommentsForPost(postId) {
        return this.comments.filter(c => c.postId === postId);
    }

    likeComment(commentId) {
        const comment = this.comments.find(c => c.id === commentId);
        if (comment) {
            comment.likes++;
        }
    }

    generateId() {
        return Math.random().toString(36).substr(2, 9);
    }
}

module.exports = CommentManager;
EOF
git add src/comments.js
git commit -m "Add comment validation and likes

Comments now require text and support likes."

echo -e "${GREEN}✅ feature/comments-system branch created (1 commit)${NC}"

# Back to master
git checkout master

# Create feature branch: auth-system
echo -e "${BLUE}🌿 Creating feature/auth-system branch...${NC}"
git checkout -b feature/auth-system  # Branch from latest master

# Switch developer: Emily Rodriguez
export GIT_AUTHOR_NAME="Emily Rodriguez"
export GIT_AUTHOR_EMAIL="emily@example.com"
export GIT_COMMITTER_NAME="Emily Rodriguez"
export GIT_COMMITTER_EMAIL="emily@example.com"

# Feature commit 1: Improve auth
export GIT_AUTHOR_DATE="2024-01-17T09:00:00"
export GIT_COMMITTER_DATE="2024-01-17T09:00:00"
cat > src/auth.js << 'EOF'
// Authentication Module

class AuthManager {
    constructor() {
        this.users = new Map();
        this.sessions = new Map();
    }

    register(username, password, email) {
        // Validate input
        if (!username || !password || !email) {
            throw new Error('All fields are required');
        }

        // Check if username exists
        for (let user of this.users.values()) {
            if (user.username === username) {
                throw new Error('Username already exists');
            }
        }

        const userId = this.generateUserId();
        this.users.set(userId, { username, password, email });
        return userId;
    }

    login(username, password) {
        for (let [userId, user] of this.users) {
            if (user.username === username && user.password === password) {
                const sessionId = this.createSession(userId);
                return sessionId;
            }
        }
        throw new Error('Invalid credentials');
    }

    logout(sessionId) {
        this.sessions.delete(sessionId);
    }

    validateSession(sessionId) {
        return this.sessions.has(sessionId);
    }

    generateUserId() {
        return Math.random().toString(36).substr(2, 9);
    }

    createSession(userId) {
        const sessionId = Math.random().toString(36).substr(2, 16);
        this.sessions.set(sessionId, userId);
        return sessionId;
    }
}

module.exports = AuthManager;
EOF
git add src/auth.js
git commit -m "Enhance authentication with validation

Add input validation, error handling, and logout."

echo -e "${GREEN}✅ feature/auth-system branch created (1 commit)${NC}"

# Back to master, add a commit that will conflict with posts-ui
git checkout master

# Switch developer: Sarah Chen
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

# Master commit 5: Add API module (will conflict with some branches)
export GIT_AUTHOR_DATE="2024-01-17T10:00:00"
export GIT_COMMITTER_DATE="2024-01-17T10:00:00"
cat > src/api.js << 'EOF'
// API Module

class APIManager {
    constructor(postManager, commentManager) {
        this.postManager = postManager;
        this.commentManager = commentManager;
    }

    getPosts() {
        return this.postManager.getAllPosts();
    }

    createPost(title, content, authorId) {
        return this.postManager.createPost(title, content, authorId);
    }

    getComments(postId) {
        return this.commentManager.getCommentsForPost(postId);
    }

    addComment(postId, userId, text) {
        return this.commentManager.addComment(postId, userId, text);
    }
}

module.exports = APIManager;
EOF
git add src/api.js
git commit -m "Add API module for unified interface

Provides clean API for frontend to use."

# Master commit 6: Update posts module (will conflict with posts-api branch)
export GIT_AUTHOR_DATE="2024-01-17T14:00:00"
export GIT_COMMITTER_DATE="2024-01-17T14:00:00"
cat > src/posts.js << 'EOF'
// Posts Management Module

class PostManager {
    constructor() {
        this.posts = [];
    }

    createPost(title, content, authorId) {
        // Add validation
        if (!title || !content) {
            throw new Error('Title and content are required');
        }

        const post = {
            id: this.generateId(),
            title,
            content,
            authorId,
            createdAt: new Date(),
            status: 'draft'
        };
        this.posts.push(post);
        return post;
    }

    publishPost(postId) {
        const post = this.posts.find(p => p.id === postId);
        if (post) {
            post.status = 'published';
            post.publishedAt = new Date();
        }
    }

    generateId() {
        return Math.random().toString(36).substr(2, 9);
    }

    getAllPosts() {
        return this.posts.filter(p => p.status === 'published');
    }
}

module.exports = PostManager;
EOF
git add src/posts.js
git commit -m "Add post validation and publishing

Posts now require validation and have draft/published status."

echo -e "${GREEN}✅ Master branch extended (6 commits total)${NC}"

# Create feature branch with conflicts: posts-api
echo -e "${BLUE}🌿 Creating feature/posts-api branch (will have conflicts)...${NC}"
git checkout -b feature/posts-api HEAD~2  # Branch before last 2 commits

# Switch developer: David Kim
export GIT_AUTHOR_NAME="David Kim"
export GIT_AUTHOR_EMAIL="david@example.com"
export GIT_COMMITTER_NAME="David Kim"
export GIT_COMMITTER_EMAIL="david@example.com"

# Feature commit: Modify posts (will conflict)
export GIT_AUTHOR_DATE="2024-01-17T11:00:00"
export GIT_COMMITTER_DATE="2024-01-17T11:00:00"
cat > src/posts.js << 'EOF'
// Posts Management Module

class PostManager {
    constructor() {
        this.posts = [];
        this.tags = new Map();
    }

    createPost(title, content, authorId, tags = []) {
        const post = {
            id: this.generateId(),
            title,
            content,
            authorId,
            tags,
            createdAt: new Date(),
            views: 0
        };
        this.posts.push(post);
        
        // Index tags
        tags.forEach(tag => {
            if (!this.tags.has(tag)) {
                this.tags.set(tag, []);
            }
            this.tags.get(tag).push(post.id);
        });
        
        return post;
    }

    getPostsByTag(tag) {
        const postIds = this.tags.get(tag) || [];
        return this.posts.filter(p => postIds.includes(p.id));
    }

    incrementViews(postId) {
        const post = this.posts.find(p => p.id === postId);
        if (post) {
            post.views++;
        }
    }

    generateId() {
        return Math.random().toString(36).substr(2, 9);
    }

    getAllPosts() {
        return this.posts;
    }
}

module.exports = PostManager;
EOF
git add src/posts.js
git commit -m "Add tags and view tracking to posts

Posts now support tagging and view counting."

echo -e "${GREEN}✅ feature/posts-api branch created (will conflict with master)${NC}"

# Create complex branch for abort exercise
git checkout master
echo -e "${BLUE}🌿 Creating feature/complex-changes branch...${NC}"
git checkout -b feature/complex-changes HEAD~3

# Multiple conflicting changes
export GIT_AUTHOR_DATE="2024-01-16T15:00:00"
export GIT_COMMITTER_DATE="2024-01-16T15:00:00"

# Modify multiple files
cat > src/blog.js << 'EOF'
// Blog Platform - Main Module
// REFACTORED VERSION

class BlogPlatform {
    constructor(config) {
        this.posts = [];
        this.authors = new Map();
        this.config = config || {};
    }

    async initialize() {
        console.log('Initializing blog platform...');
        await this.loadConfiguration();
        await this.loadPosts();
        console.log('Blog platform ready!');
    }

    async loadConfiguration() {
        // Load config from file
        console.log('Loading configuration...');
    }

    async loadPosts() {
        // Load posts asynchronously
        console.log('Loading posts from database...');
    }
}

module.exports = BlogPlatform;
EOF

cat > src/comments.js << 'EOF'
// Comments System Module
// REFACTORED VERSION

class CommentManager {
    constructor(database) {
        this.comments = [];
        this.database = database;
    }

    async addComment(postId, userId, text) {
        const comment = {
            id: await this.generateId(),
            postId,
            userId,
            text,
            createdAt: new Date(),
            replies: []
        };
        
        await this.database.save(comment);
        this.comments.push(comment);
        return comment;
    }

    async getCommentsForPost(postId) {
        return this.comments.filter(c => c.postId === postId);
    }

    async addReply(commentId, userId, text) {
        const comment = this.comments.find(c => c.id === commentId);
        if (comment) {
            comment.replies.push({ userId, text, createdAt: new Date() });
            await this.database.update(comment);
        }
    }

    async generateId() {
        return Math.random().toString(36).substr(2, 9);
    }
}

module.exports = CommentManager;
EOF

git add src/blog.js src/comments.js
git commit -m "Major refactor: async/await and database integration

This will cause many conflicts with master."

echo -e "${GREEN}✅ feature/complex-changes branch created (for abort practice)${NC}"

# Create branch for cleanup exercise
git checkout master
echo -e "${BLUE}🌿 Creating feature/needs-cleanup branch...${NC}"
git checkout -b feature/needs-cleanup

# Switch developer: Sarah Chen
export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

# Make messy WIP commits
export GIT_AUTHOR_DATE="2024-01-18T09:00:00"
export GIT_COMMITTER_DATE="2024-01-18T09:00:00"
cat > src/search.js << 'EOF'
// Search functionality
function search(query) {
    console.log('Searching for: ' + query);
}
module.exports = { search };
EOF
git add src/search.js
git commit -m "WIP: start search feature"

export GIT_AUTHOR_DATE="2024-01-18T09:30:00"
export GIT_COMMITTER_DATE="2024-01-18T09:30:00"
cat > src/search.js << 'EOF'
// Search functionality
function search(query) {
    console.log('Searching for: ' + query);
    // TODO: implement
    return [];
}
module.exports = { search };
EOF
git add src/search.js
git commit -m "WIP: add return"

export GIT_AUTHOR_DATE="2024-01-18T10:00:00"
export GIT_COMMITTER_DATE="2024-01-18T10:00:00"
cat > src/search.js << 'EOF'
// Search functionality
function search(query, posts) {
    console.log('Searching for: ' + query);
    
    return posts.filter(post => 
        post.title.includes(query) || post.content.includes(query)
    );
}
module.exports = { search };
EOF
git add src/search.js
git commit -m "WIP: basic implementation"

export GIT_AUTHOR_DATE="2024-01-18T10:30:00"
export GIT_COMMITTER_DATE="2024-01-18T10:30:00"
cat > src/search.js << 'EOF'
// Search functionality

function search(query, posts) {
    if (!query || query.trim().length === 0) {
        return posts;
    }
    
    const lowerQuery = query.toLowerCase();
    
    return posts.filter(post => 
        post.title.toLowerCase().includes(lowerQuery) || 
        post.content.toLowerCase().includes(lowerQuery)
    );
}

module.exports = { search };
EOF
git add src/search.js
git commit -m "Complete search feature"

# Add tests
export GIT_AUTHOR_DATE="2024-01-18T11:00:00"
export GIT_COMMITTER_DATE="2024-01-18T11:00:00"
cat > src/search.test.js << 'EOF'
const { search } = require('./search');

const mockPosts = [
    { title: 'Hello World', content: 'This is a test' },
    { title: 'Another Post', content: 'More content here' }
];

console.log('Testing search...');
const results = search('hello', mockPosts);
console.log('Results:', results.length);
EOF
git add src/search.test.js
git commit -m "Add basic tests for search"

echo -e "${GREEN}✅ feature/needs-cleanup branch created (5 messy commits)${NC}"

# Create branch for in-progress work
git checkout master
echo -e "${BLUE}🌿 Creating feature/in-progress branch...${NC}"
git checkout -b feature/in-progress

export GIT_AUTHOR_DATE="2024-01-18T14:00:00"
export GIT_COMMITTER_DATE="2024-01-18T14:00:00"
cat > src/notifications.js << 'EOF'
// Notification system
class NotificationManager {
    constructor() {
        this.notifications = [];
    }

    notify(userId, message) {
        this.notifications.push({ userId, message, read: false });
    }
}
module.exports = NotificationManager;
EOF
git add src/notifications.js
git commit -m "Start notification system"

echo -e "${GREEN}✅ feature/in-progress branch created${NC}"

# Return to master and add more commits
git checkout master

# Continue building master branch with more modules
export GIT_AUTHOR_NAME="Marcus Rodriguez"
export GIT_AUTHOR_EMAIL="marcus@example.com"
export GIT_COMMITTER_NAME="Marcus Rodriguez"
export GIT_COMMITTER_EMAIL="marcus@example.com"

export GIT_AUTHOR_DATE="2024-01-19T09:00:00"
export GIT_COMMITTER_DATE="2024-01-19T09:00:00"
cat > src/database.js << 'EOF'
// Database Abstraction Layer

class Database {
    constructor(config) {
        this.config = config;
        this.connection = null;
    }

    async connect() {
        console.log('Connecting to database...');
        this.connection = {}; // Mock connection
        return this.connection;
    }

    async query(sql, params) {
        console.log('Executing query:', sql);
        return [];
    }

    async insert(table, data) {
        console.log('Inserting into', table, data);
        return { id: Math.random() };
    }

    async update(table, id, data) {
        console.log('Updating', table, id, data);
        return true;
    }

    async delete(table, id) {
        console.log('Deleting from', table, id);
        return true;
    }
}

module.exports = Database;
EOF
git add src/database.js
git commit -m "Add database abstraction layer"

export GIT_AUTHOR_DATE="2024-01-19T10:00:00"
export GIT_COMMITTER_DATE="2024-01-19T10:00:00"
cat > src/config.js << 'EOF'
// Application Configuration

const config = {
    database: {
        host: 'localhost',
        port: 5432,
        name: 'blog_db'
    },
    server: {
        port: 3000,
        host: '0.0.0.0'
    },
    auth: {
        secretKey: 'your-secret-key',
        tokenExpiry: '24h'
    },
    features: {
        comments: true,
        likes: true,
        sharing: true
    }
};

module.exports = config;
EOF
git add src/config.js
git commit -m "Add application configuration"

export GIT_AUTHOR_DATE="2024-01-19T11:00:00"
export GIT_COMMITTER_DATE="2024-01-19T11:00:00"
cat > src/logger.js << 'EOF'
// Logging Infrastructure

class Logger {
    constructor(name) {
        this.name = name;
        this.levels = ['DEBUG', 'INFO', 'WARN', 'ERROR'];
    }

    debug(message, data) {
        this.log('DEBUG', message, data);
    }

    info(message, data) {
        this.log('INFO', message, data);
    }

    warn(message, data) {
        this.log('WARN', message, data);
    }

    error(message, data) {
        this.log('ERROR', message, data);
    }

    log(level, message, data) {
        const timestamp = new Date().toISOString();
        console.log(`[${timestamp}] [${level}] [${this.name}] ${message}`, data || '');
    }
}

module.exports = Logger;
EOF
git add src/logger.js
git commit -m "Add logging infrastructure"

export GIT_AUTHOR_NAME="Aisha Patel"
export GIT_AUTHOR_EMAIL="aisha@example.com"
export GIT_COMMITTER_NAME="Aisha Patel"
export GIT_COMMITTER_EMAIL="aisha@example.com"

export GIT_AUTHOR_DATE="2024-01-19T14:00:00"
export GIT_COMMITTER_DATE="2024-01-19T14:00:00"
cat > src/email.js << 'EOF'
// Email Service Module

class EmailService {
    constructor(config) {
        this.config = config;
        this.transporter = null;
    }

    async initialize() {
        console.log('Initializing email service...');
        // Setup email transporter
    }

    async sendEmail(to, subject, body) {
        console.log(`Sending email to ${to}: ${subject}`);
        return { success: true, messageId: 'msg_' + Date.now() };
    }

    async sendWelcomeEmail(user) {
        return this.sendEmail(
            user.email,
            'Welcome to our blog!',
            `Hello ${user.name}, welcome to our platform!`
        );
    }

    async sendPasswordReset(user, token) {
        return this.sendEmail(
            user.email,
            'Password Reset Request',
            `Click here to reset: /reset/${token}`
        );
    }
}

module.exports = EmailService;
EOF
git add src/email.js
git commit -m "Add email service module"

# Create more feature branches
echo -e "${BLUE}🌿 Creating feature/search-improvements branch...${NC}"
git checkout -b feature/search-improvements

export GIT_AUTHOR_DATE="2024-01-20T09:00:00"
export GIT_COMMITTER_DATE="2024-01-20T09:00:00"
cat > src/search.js << 'EOF'
// Advanced Search Module

class SearchEngine {
    constructor() {
        this.index = new Map();
    }

    indexPost(post) {
        const words = this.tokenize(post.title + ' ' + post.content);
        words.forEach(word => {
            if (!this.index.has(word)) {
                this.index.set(word, new Set());
            }
            this.index.get(word).add(post.id);
        });
    }

    tokenize(text) {
        return text.toLowerCase()
            .replace(/[^\w\s]/g, '')
            .split(/\s+/)
            .filter(word => word.length > 2);
    }

    search(query) {
        const words = this.tokenize(query);
        const results = new Set();
        
        words.forEach(word => {
            const postIds = this.index.get(word);
            if (postIds) {
                postIds.forEach(id => results.add(id));
            }
        });
        
        return Array.from(results);
    }

    buildIndex(posts) {
        posts.forEach(post => this.indexPost(post));
    }
}

module.exports = SearchEngine;
EOF
git add src/search.js
git commit -m "Implement advanced search with indexing"

export GIT_AUTHOR_DATE="2024-01-20T10:00:00"
export GIT_COMMITTER_DATE="2024-01-20T10:00:00"
cat >> src/search.js << 'EOF'

// Tag and author search filters
function searchByTags(posts, tags) {
    return posts.filter(post => 
        post.tags && tags.some(tag => post.tags.includes(tag))
    );
}

function searchByAuthor(posts, authorId) {
    return posts.filter(post => post.authorId === authorId);
}

module.exports.searchByTags = searchByTags;
module.exports.searchByAuthor = searchByAuthor;
EOF
git add src/search.js
git commit -m "Add tag and author search filters"

git checkout master

# Continue with more master commits
echo -e "${BLUE}🌿 Creating feature/rich-text-editor branch...${NC}"
git checkout -b feature/rich-text-editor

export GIT_AUTHOR_NAME="Jake Thompson"
export GIT_AUTHOR_EMAIL="jake@example.com"
export GIT_COMMITTER_NAME="Jake Thompson"
export GIT_COMMITTER_EMAIL="jake@example.com"

export GIT_AUTHOR_DATE="2024-01-20T11:00:00"
export GIT_COMMITTER_DATE="2024-01-20T11:00:00"
cat > src/editor.js << 'EOF'
// Rich Text Editor Component

class RichTextEditor {
    constructor(elementId) {
        this.element = document.getElementById(elementId);
        this.toolbar = null;
        this.content = '';
    }

    initialize() {
        this.createToolbar();
        this.attachEventHandlers();
    }

    createToolbar() {
        this.toolbar = document.createElement('div');
        this.toolbar.className = 'editor-toolbar';
        
        const tools = ['bold', 'italic', 'underline', 'link'];
        tools.forEach(tool => {
            const btn = document.createElement('button');
            btn.textContent = tool;
            btn.onclick = () => this.applyFormat(tool);
            this.toolbar.appendChild(btn);
        });
        
        this.element.parentNode.insertBefore(this.toolbar, this.element);
    }

    applyFormat(format) {
        document.execCommand(format, false, null);
    }

    getContent() {
        return this.element.innerHTML;
    }

    setContent(html) {
        this.element.innerHTML = html;
    }

    attachEventHandlers() {
        this.element.addEventListener('input', () => {
            this.content = this.getContent();
        });
    }
}

module.exports = RichTextEditor;
EOF
git add src/editor.js
git commit -m "Add rich text editor component"

export GIT_AUTHOR_DATE="2024-01-20T12:00:00"
export GIT_COMMITTER_DATE="2024-01-20T12:00:00"
cat >> src/editor.js << 'EOF'

// Image and code block support
RichTextEditor.prototype.insertImage = function(url) {
    const img = `<img src="${url}" alt="Inserted image" />`;
    document.execCommand('insertHTML', false, img);
};

RichTextEditor.prototype.insertCodeBlock = function(code) {
    const pre = `<pre><code>${code}</code></pre>`;
    document.execCommand('insertHTML', false, pre);
};
EOF
git add src/editor.js
git commit -m "Add image and code block support to editor"

git checkout master

export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

export GIT_AUTHOR_DATE="2024-01-21T09:00:00"
export GIT_COMMITTER_DATE="2024-01-21T09:00:00"
cat > src/categories.js << 'EOF'
// Category Management System

class CategoryManager {
    constructor() {
        this.categories = [];
    }

    addCategory(name, description) {
        const category = {
            id: this.generateId(),
            name,
            description,
            postCount: 0,
            createdAt: new Date()
        };
        this.categories.push(category);
        return category;
    }

    getCategory(id) {
        return this.categories.find(c => c.id === id);
    }

    getAllCategories() {
        return this.categories;
    }

    deleteCategory(id) {
        const index = this.categories.findIndex(c => c.id === id);
        if (index !== -1) {
            this.categories.splice(index, 1);
            return true;
        }
        return false;
    }

    generateId() {
        return Math.random().toString(36).substr(2, 9);
    }
}

module.exports = CategoryManager;
EOF
git add src/categories.js
git commit -m "Add category management system"

export GIT_AUTHOR_DATE="2024-01-21T10:00:00"
export GIT_COMMITTER_DATE="2024-01-21T10:00:00"
cat > src/profiles.js << 'EOF'
// User Profile Management

class ProfileManager {
    constructor(database) {
        this.database = database;
        this.profiles = new Map();
    }

    async createProfile(userId, data) {
        const profile = {
            userId,
            displayName: data.displayName,
            bio: data.bio || '',
            avatar: data.avatar || '/default-avatar.png',
            social: data.social || {},
            createdAt: new Date()
        };
        
        this.profiles.set(userId, profile);
        await this.database.insert('profiles', profile);
        return profile;
    }

    async getProfile(userId) {
        if (this.profiles.has(userId)) {
            return this.profiles.get(userId);
        }
        const profile = await this.database.query('SELECT * FROM profiles WHERE userId = ?', [userId]);
        return profile;
    }

    async updateProfile(userId, updates) {
        const profile = this.profiles.get(userId);
        if (profile) {
            Object.assign(profile, updates);
            await this.database.update('profiles', userId, profile);
            return profile;
        }
        return null;
    }
}

module.exports = ProfileManager;
EOF
git add src/profiles.js
git commit -m "Add user profile management"

# Create markdown feature branch
echo -e "${BLUE}🌿 Creating feature/markdown-support branch...${NC}"
git checkout -b feature/markdown-support

export GIT_AUTHOR_NAME="Marcus Rodriguez"
export GIT_AUTHOR_EMAIL="marcus@example.com"
export GIT_COMMITTER_NAME="Marcus Rodriguez"
export GIT_COMMITTER_EMAIL="marcus@example.com"

export GIT_AUTHOR_DATE="2024-01-21T14:00:00"
export GIT_COMMITTER_DATE="2024-01-21T14:00:00"
cat > src/markdown.js << 'EOF'
// Markdown Parser

class MarkdownParser {
    parse(markdown) {
        let html = markdown;
        
        // Headers
        html = html.replace(/^### (.+)$/gm, '<h3>$1</h3>');
        html = html.replace(/^## (.+)$/gm, '<h2>$1</h2>');
        html = html.replace(/^# (.+)$/gm, '<h1>$1</h1>');
        
        // Bold and italic
        html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
        html = html.replace(/\*(.+?)\*/g, '<em>$1</em>');
        
        // Links
        html = html.replace(/\[(.+?)\]\((.+?)\)/g, '<a href="$2">$1</a>');
        
        // Code
        html = html.replace(/`(.+?)`/g, '<code>$1</code>');
        
        return html;
    }
}

module.exports = MarkdownParser;
EOF
git add src/markdown.js
git commit -m "Add markdown parser"

export GIT_AUTHOR_DATE="2024-01-21T15:00:00"
export GIT_COMMITTER_DATE="2024-01-21T15:00:00"
cat >> src/markdown.js << 'EOF'

// List parsing support
MarkdownParser.prototype.parseLists = function(markdown) {
    // Unordered lists
    let html = markdown.replace(/^\* (.+)$/gm, '<li>$1</li>');
    html = html.replace(/(<li>.+<\/li>)/s, '<ul>$1</ul>');
    
    // Ordered lists
    html = html.replace(/^\d+\. (.+)$/gm, '<li>$1</li>');
    
    return html;
};
EOF
git add src/markdown.js
git commit -m "Add list parsing to markdown"

git checkout master

export GIT_AUTHOR_NAME="Aisha Patel"
export GIT_AUTHOR_EMAIL="aisha@example.com"
export GIT_COMMITTER_NAME="Aisha Patel"
export GIT_COMMITTER_EMAIL="aisha@example.com"

export GIT_AUTHOR_DATE="2024-01-22T09:00:00"
export GIT_COMMITTER_DATE="2024-01-22T09:00:00"
cat > src/analytics.js << 'EOF'
// Analytics Tracking Module

class Analytics {
    constructor() {
        this.events = [];
        this.pageViews = new Map();
    }

    trackPageView(url, userId) {
        const event = {
            type: 'pageview',
            url,
            userId,
            timestamp: new Date()
        };
        this.events.push(event);
        
        const count = this.pageViews.get(url) || 0;
        this.pageViews.set(url, count + 1);
    }

    trackEvent(category, action, label, value) {
        const event = {
            type: 'event',
            category,
            action,
            label,
            value,
            timestamp: new Date()
        };
        this.events.push(event);
    }

    getPageViewCount(url) {
        return this.pageViews.get(url) || 0;
    }

    getEvents(filter) {
        if (filter) {
            return this.events.filter(e => e.category === filter);
        }
        return this.events;
    }
}

module.exports = Analytics;
EOF
git add src/analytics.js
git commit -m "Add analytics tracking"

export GIT_AUTHOR_DATE="2024-01-22T10:00:00"
export GIT_COMMITTER_DATE="2024-01-22T10:00:00"
cat > src/media.js << 'EOF'
// Media Upload and Management

class MediaManager {
    constructor(storage) {
        this.storage = storage;
        this.uploads = [];
    }

    async uploadFile(file, userId) {
        const fileId = this.generateId();
        const url = await this.storage.save(fileId, file);
        
        const upload = {
            id: fileId,
            userId,
            filename: file.name,
            size: file.size,
            type: file.type,
            url,
            uploadedAt: new Date()
        };
        
        this.uploads.push(upload);
        return upload;
    }

    async getFile(fileId) {
        return this.uploads.find(u => u.id === fileId);
    }

    async deleteFile(fileId) {
        const index = this.uploads.findIndex(u => u.id === fileId);
        if (index !== -1) {
            await this.storage.delete(fileId);
            this.uploads.splice(index, 1);
            return true;
        }
        return false;
    }

    getUserUploads(userId) {
        return this.uploads.filter(u => u.userId === userId);
    }

    generateId() {
        return 'file_' + Math.random().toString(36).substr(2, 9);
    }
}

module.exports = MediaManager;
EOF
git add src/media.js
git commit -m "Add media upload functionality"

# Create social features branch
echo -e "${BLUE}🌿 Creating feature/social-features branch...${NC}"
git checkout -b feature/social-features

export GIT_AUTHOR_NAME="Jake Thompson"
export GIT_AUTHOR_EMAIL="jake@example.com"
export GIT_COMMITTER_NAME="Jake Thompson"
export GIT_COMMITTER_EMAIL="jake@example.com"

export GIT_AUTHOR_DATE="2024-01-22T14:00:00"
export GIT_COMMITTER_DATE="2024-01-22T14:00:00"
cat > src/social.js << 'EOF'
// Social Features Module

class SocialManager {
    constructor() {
        this.follows = new Map();
        this.likes = new Map();
        this.shares = [];
    }

    follow(userId, targetUserId) {
        if (!this.follows.has(userId)) {
            this.follows.set(userId, new Set());
        }
        this.follows.get(userId).add(targetUserId);
        return true;
    }

    unfollow(userId, targetUserId) {
        if (this.follows.has(userId)) {
            this.follows.get(userId).delete(targetUserId);
            return true;
        }
        return false;
    }

    getFollowers(userId) {
        const followers = [];
        this.follows.forEach((following, follower) => {
            if (following.has(userId)) {
                followers.push(follower);
            }
        });
        return followers;
    }

    getFollowing(userId) {
        return Array.from(this.follows.get(userId) || []);
    }

    likePost(userId, postId) {
        const key = `${userId}:${postId}`;
        this.likes.set(key, { userId, postId, timestamp: new Date() });
    }

    sharePost(userId, postId, platform) {
        this.shares.push({
            userId,
            postId,
            platform,
            timestamp: new Date()
        });
    }
}

module.exports = SocialManager;
EOF
git add src/social.js
git commit -m "Add social features: follow, like, share"

export GIT_AUTHOR_DATE="2024-01-22T15:00:00"
export GIT_COMMITTER_DATE="2024-01-22T15:00:00"
cat >> src/social.js << 'EOF'

// Feed generation for followed users
SocialManager.prototype.generateFeed = function(userId, posts) {
    const following = this.getFollowing(userId);
    const feedPosts = posts.filter(post => 
        following.includes(post.authorId) || post.authorId === userId
    );
    
    return feedPosts.sort((a, b) => 
        new Date(b.createdAt) - new Date(a.createdAt)
    );
};
EOF
git add src/social.js
git commit -m "Add feed generation for followed users"

git checkout master

export GIT_AUTHOR_NAME="Sarah Chen"
export GIT_AUTHOR_EMAIL="sarah@example.com"
export GIT_COMMITTER_NAME="Sarah Chen"
export GIT_COMMITTER_EMAIL="sarah@example.com"

export GIT_AUTHOR_DATE="2024-01-23T09:00:00"
export GIT_COMMITTER_DATE="2024-01-23T09:00:00"
cat > src/moderation.js << 'EOF'
// Content Moderation System

class ModerationManager {
    constructor() {
        this.bannedWords = new Set();
        this.flaggedContent = [];
        this.moderators = new Set();
    }

    addBannedWord(word) {
        this.bannedWords.add(word.toLowerCase());
    }

    checkContent(content) {
        const words = content.toLowerCase().split(/\s+/);
        const violations = words.filter(word => this.bannedWords.has(word));
        
        if (violations.length > 0) {
            return { allowed: false, violations };
        }
        return { allowed: true };
    }

    flagContent(contentId, reason, reporterId) {
        this.flaggedContent.push({
            contentId,
            reason,
            reporterId,
            timestamp: new Date(),
            status: 'pending'
        });
    }

    getFlaggedContent() {
        return this.flaggedContent.filter(f => f.status === 'pending');
    }

    moderateContent(contentId, decision, moderatorId) {
        const item = this.flaggedContent.find(f => f.contentId === contentId);
        if (item) {
            item.status = decision;
            item.moderatedBy = moderatorId;
            item.moderatedAt = new Date();
            return true;
        }
        return false;
    }
}

module.exports = ModerationManager;
EOF
git add src/moderation.js
git commit -m "Add content moderation system"

export GIT_AUTHOR_DATE="2024-01-23T10:00:00"
export GIT_COMMITTER_DATE="2024-01-23T10:00:00"
cat > src/rss.js << 'EOF'
// RSS Feed Generation

class RSSGenerator {
    constructor(siteConfig) {
        this.config = siteConfig;
    }

    generateFeed(posts) {
        const items = posts.map(post => this.generateItem(post)).join('');
        
        return `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>${this.config.title}</title>
    <link>${this.config.url}</link>
    <description>${this.config.description}</description>
    ${items}
  </channel>
</rss>`;
    }

    generateItem(post) {
        return `
    <item>
      <title>${this.escapeXml(post.title)}</title>
      <link>${this.config.url}/posts/${post.id}</link>
      <description>${this.escapeXml(post.excerpt)}</description>
      <pubDate>${new Date(post.createdAt).toUTCString()}</pubDate>
    </item>`;
    }

    escapeXml(text) {
        return text
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&apos;');
    }
}

module.exports = RSSGenerator;
EOF
git add src/rss.js
git commit -m "Add RSS feed generation"

# Create performance branch
echo -e "${BLUE}🌿 Creating feature/performance branch...${NC}"
git checkout -b feature/performance

export GIT_AUTHOR_NAME="Marcus Rodriguez"
export GIT_AUTHOR_EMAIL="marcus@example.com"
export GIT_COMMITTER_NAME="Marcus Rodriguez"
export GIT_COMMITTER_EMAIL="marcus@example.com"

export GIT_AUTHOR_DATE="2024-01-23T14:00:00"
export GIT_COMMITTER_DATE="2024-01-23T14:00:00"
cat > src/cache.js << 'EOF'
// Caching Layer for Performance

class CacheManager {
    constructor(ttl = 3600000) {
        this.cache = new Map();
        this.ttl = ttl; // Time to live in milliseconds
    }

    set(key, value) {
        const expiresAt = Date.now() + this.ttl;
        this.cache.set(key, { value, expiresAt });
    }

    get(key) {
        const item = this.cache.get(key);
        
        if (!item) {
            return null;
        }
        
        if (Date.now() > item.expiresAt) {
            this.cache.delete(key);
            return null;
        }
        
        return item.value;
    }

    delete(key) {
        return this.cache.delete(key);
    }

    clear() {
        this.cache.clear();
    }

    size() {
        return this.cache.size;
    }
}

module.exports = CacheManager;
EOF
git add src/cache.js
git commit -m "Add caching layer for performance"

export GIT_AUTHOR_DATE="2024-01-23T15:00:00"
export GIT_COMMITTER_DATE="2024-01-23T15:00:00"
cat >> src/cache.js << 'EOF'

// Automatic cache cleanup
CacheManager.prototype.startCleanup = function(interval = 60000) {
    this.cleanupInterval = setInterval(() => {
        const now = Date.now();
        const keysToDelete = [];
        
        this.cache.forEach((item, key) => {
            if (now > item.expiresAt) {
                keysToDelete.push(key);
            }
        });
        
        keysToDelete.forEach(key => this.cache.delete(key));
    }, interval);
};
EOF
git add src/cache.js
git commit -m "Add automatic cache cleanup"

git checkout master

export GIT_AUTHOR_NAME="Aisha Patel"
export GIT_AUTHOR_EMAIL="aisha@example.com"
export GIT_COMMITTER_NAME="Aisha Patel"
export GIT_COMMITTER_EMAIL="aisha@example.com"

export GIT_AUTHOR_DATE="2024-01-24T09:00:00"
export GIT_COMMITTER_DATE="2024-01-24T09:00:00"
cat > src/seo.js << 'EOF'
// SEO Optimization Tools

class SEOManager {
    generateMetaTags(post) {
        return {
            title: post.title,
            description: this.generateDescription(post),
            keywords: this.generateKeywords(post),
            ogTitle: post.title,
            ogDescription: this.generateDescription(post),
            ogImage: post.featuredImage || '/default-og-image.png'
        };
    }

    generateDescription(post) {
        const text = post.content.replace(/<[^>]*>/g, '');
        return text.substring(0, 160) + (text.length > 160 ? '...' : '');
    }

    generateKeywords(post) {
        if (post.tags) {
            return post.tags.join(', ');
        }
        return '';
    }

    generateSitemap(posts) {
        const urls = posts.map(post => ({
            loc: `/posts/${post.id}`,
            lastmod: post.updatedAt || post.createdAt,
            changefreq: 'weekly',
            priority: 0.8
        }));
        
        return urls;
    }
}

module.exports = SEOManager;
EOF
git add src/seo.js
git commit -m "Add SEO optimization tools"

export GIT_AUTHOR_DATE="2024-01-24T10:00:00"
export GIT_COMMITTER_DATE="2024-01-24T10:00:00"
cat > README.md << 'EOF'
# Blog Platform

A modern blogging platform with rich features.

## Features

- User authentication and profiles
- Rich text editor
- Categories and tags  
- Social features (follow, like, share)
- Analytics tracking
- Content moderation
- RSS feeds
- SEO optimization

## Tech Stack

- Node.js
- JavaScript ES6+
- Database abstraction layer

## Getting Started

1. Install dependencies
2. Configure database
3. Run migrations
4. Start server

## License

MIT
EOF
git add README.md
git commit -m "Add comprehensive README"

echo ""
echo -e "${GREEN}✅ Git history setup complete!${NC}"
echo ""
echo -e "${BLUE}📊 Repository Summary:${NC}"
echo "  • Master branch: 18 commits with full feature set"
echo "  • feature/posts-ui: ready for clean rebase"
echo "  • feature/comments-system: ready for rebase"
echo "  • feature/auth-system: ready for fast-forward"
echo "  • feature/posts-api: will have conflicts with master"
echo "  • feature/complex-changes: many conflicts (for abort practice)"
echo "  • feature/needs-cleanup: messy commits (for interactive rebase)"
echo "  • feature/in-progress: simulates ongoing work"
echo "  • feature/search-improvements: advanced search features"
echo "  • feature/rich-text-editor: editor enhancements"
echo "  • feature/markdown-support: markdown parsing"
echo "  • feature/social-features: follow/like/share"
echo "  • feature/performance: caching improvements"
echo ""
echo -e "${BLUE}🎯 Ready for exercises!${NC}"
echo "  Run: git log --oneline --graph --all"
echo "  Start with: EXERCISES.md"
echo ""
