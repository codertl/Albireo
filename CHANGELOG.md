#0.0.2

##Features Add

- Home api for end user
- Episodes api for managing episodes
- Alembic SQLAlchemy migrate tool for migrate database
- Vagrant support for a quickly deployment with Vagrant
- Episode thumbnail generation
- Bangumi cover now will downloaded to local server

##Breaking Changes
- get bangumi api now return all episodes of this bangumi. access it with `episodes` field
- init db using sql script is not recommended, using tools.py to init db.
- ffmpeg is now a dependency to generate thumbnail for episode