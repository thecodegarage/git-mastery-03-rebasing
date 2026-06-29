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

# Check if src/ directory already exists
if [ -d "src" ]; then
    echo -e "${YELLOW}⚠️  Warning: src/ directory already exists${NC}"
    read -p "Delete and rebuild? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi
    rm -rf src/
    # Clean up any existing branches
    git branch | grep -v "^\*" | grep -v "master" | grep -v "main" | xargs -r git branch -D 2>/dev/null || true
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

# Return to master
git checkout master

echo ""
echo -e "${GREEN}✅ Git history setup complete!${NC}"
echo ""
echo -e "${BLUE}📊 Repository Summary:${NC}"
echo "  • Master branch: 6 commits"
echo "  • feature/posts-ui: ready for clean rebase"
echo "  • feature/comments-system: ready for rebase"
echo "  • feature/auth-system: ready for fast-forward"
echo "  • feature/posts-api: will have conflicts with master"
echo "  • feature/complex-changes: many conflicts (for abort practice)"
echo "  • feature/needs-cleanup: messy commits (for interactive rebase)"
echo "  • feature/in-progress: simulates ongoing work"
echo ""
echo -e "${BLUE}🎯 Ready for exercises!${NC}"
echo "  Run: git log --oneline --graph --all"
echo "  Start with: EXERCISES.md"
echo ""
