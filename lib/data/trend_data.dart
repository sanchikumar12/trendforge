import '../models/models.dart';

const List<TrendTopic> kTrendRadarTopics = [
  TrendTopic(
    id: 'tr_1', niche: 'AI & Tech',
    topic: 'Why Reasoning Models Are Replacing 80% of Traditional Prompt Engineering',
    velocityScore: 98, scrollStopProbability: 94,
    sampleHook: 'Stop spending 2 hours tweaking prompts. Reasoning models just changed the rules forever:',
    source: 'X Algorithm', growthBadge: '+340% 24h Surge',
    tags: ['AI Agents', 'Prompting', 'Productivity'],
  ),
  TrendTopic(
    id: 'tr_2', niche: 'Solopreneurs',
    topic: 'The \$10k/Month Solo Stack: 3 Micro-SaaS Tools & 1 Agent',
    velocityScore: 95, scrollStopProbability: 92,
    sampleHook: 'You don\'t need a 10-person team in 2026. Here is the exact stack running a \$100k business with 0 employees:',
    source: 'LinkedIn Trends', growthBadge: '+210% Growth',
    tags: ['Solopreneur', 'SaaS', 'Bootstrapping'],
  ),
  TrendTopic(
    id: 'tr_3', niche: 'B2B Marketing',
    topic: 'Why Gated Whitepapers Are Dead (And What Top 1% Brands Do Instead)',
    velocityScore: 89, scrollStopProbability: 88,
    sampleHook: 'Nobody wants to fill a 6-field form for a 20-page PDF anymore. Here is the frictionless playbook:',
    source: 'LinkedIn Trends', growthBadge: 'High Engagement',
    tags: ['B2B', 'DemandGen', 'ContentStrategy'],
  ),
  TrendTopic(
    id: 'tr_4', niche: 'Creator Economy',
    topic: 'The Visual Breakdown Blueprint: Why Carousels Drive 4.2x More Saves Than Reels',
    velocityScore: 93, scrollStopProbability: 96,
    sampleHook: 'The algorithm loves "Saves" more than Likes. Here is the 6-slide carousel formula that forces people to bookmark:',
    source: 'Newsletter Index', growthBadge: 'Viral Pattern',
    tags: ['CreatorEconomy', 'Carousels', 'AlgorithmHack'],
  ),
  TrendTopic(
    id: 'tr_5', niche: 'Leadership',
    topic: 'The 3-Sentence Feedback Framework That High-Growth Founders Swear By',
    velocityScore: 86, scrollStopProbability: 85,
    sampleHook: 'Most managers give feedback that demotivates. Use this 3-sentence radical clarity rule instead:',
    source: 'Reddit /r/growth', growthBadge: 'Top Bookmark',
    tags: ['Leadership', 'Management', 'Culture'],
  ),
  TrendTopic(
    id: 'tr_6', niche: 'Finance',
    topic: 'Capital Efficiency in 2026: Why Profitable Micro-Agencies Beat VC-Backed Startups',
    velocityScore: 91, scrollStopProbability: 90,
    sampleHook: 'Valuations are vanity. Free cash flow is sanity. The mathematical breakdown:',
    source: 'Google Search Wave', growthBadge: '+180% Interest',
    tags: ['Finance', 'CashFlow', 'Investing'],
  ),
  TrendTopic(
    id: 'tr_7', niche: 'AI & Tech',
    topic: 'Local AI on Consumer Laptops: The Death of Token Bills',
    velocityScore: 96, scrollStopProbability: 93,
    sampleHook: 'Why I stopped paying \$200/mo in API bills and moved my entire workflow offline:',
    source: 'X Algorithm', growthBadge: '+280% Velocity',
    tags: ['LocalAI', 'Ollama', 'OpenSource'],
  ),
  TrendTopic(
    id: 'tr_8', niche: 'Creator Economy',
    topic: 'From 0 to 50k Followers: The 80/20 Hook Writing Formula',
    velocityScore: 94, scrollStopProbability: 97,
    sampleHook: '90% of your post\'s success is decided in the first 1.8 seconds. Master these 4 triggers:',
    source: 'LinkedIn Trends', growthBadge: 'Peak Traction',
    tags: ['Copywriting', 'PersonalBrand', 'Hooks'],
  ),
];

const List<String> kNicheFilters = [
  'All Niches', 'AI & Tech', 'Solopreneurs', 'B2B Marketing',
  'Creator Economy', 'Leadership', 'Finance',
];
