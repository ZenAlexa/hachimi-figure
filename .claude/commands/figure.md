HachimiFigure specific task: $ARGUMENTS

Project context:
- HachimiFigure is a SAAS for converting 2D anime illustrations to 3D figure-style images
- Target users: illustrators, anime fans, small IP teams
- Core features: character consistency, stylization control, text protection

Key directories:
- Generate page: /app/[locale]/(basic-layout)/generate
- API routes: /app/api/figure
- Components: /components/figure
- Database: /lib/db/schema.ts (figure_generations, figure_styles tables)

When implementing features, consider:
1. Credit/points system integration
2. Multi-language support (zh, en, ja)
3. Image processing pipeline
4. User history and gallery
