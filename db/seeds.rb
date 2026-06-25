puts "Cleaning database..."

Candidate.destroy_all
Search.destroy_all

puts "Creating searches..."

rails_search = Search.create!(
  job_title: "Senior Ruby on Rails Developer",
  job_description: "We are looking for a senior backend developer with strong Ruby on Rails experience, good product sense, and the ability to work closely with founders and product teams."
)

ai_engineer_search = Search.create!(
  job_title: "AI Engineer",
  job_description: "We are looking for an AI Engineer with experience building LLM-powered features, working with APIs, RAG pipelines, embeddings, and production-ready AI systems."
)

cto_search = Search.create!(
  job_title: "CTO / Head of Engineering",
  job_description: "We are looking for a technical leader able to manage an engineering team, define the technical roadmap, improve delivery, and stay hands-on when needed."
)

puts "Creating candidates..."

Candidate.create!(
  full_name: "Alice Martin",
  summary: "Senior Rails developer with 8 years of experience building SaaS products. Strong backend skills and good understanding of product requirements.",
  linkedin_profile: "https://www.linkedin.com/in/alice-martin",
  github_profile: "https://github.com/alicemartin",
  search: rails_search
)

Candidate.create!(
  full_name: "Thomas Bernard",
  summary: "Backend engineer specialized in Ruby on Rails, PostgreSQL, Sidekiq, and API design. Previously worked in fast-growing startups.",
  linkedin_profile: "https://www.linkedin.com/in/thomas-bernard",
  github_profile: "https://github.com/thomasbernard",
  search: rails_search
)

Candidate.create!(
  full_name: "Sarah Dupont",
  summary: "AI Engineer with experience in LLM applications, vector databases, embeddings, and retrieval-augmented generation.",
  linkedin_profile: "https://www.linkedin.com/in/sarah-dupont",
  github_profile: "https://github.com/sarahdupont",
  search: ai_engineer_search
)

Candidate.create!(
  full_name: "Mehdi Laurent",
  summary: "Machine learning engineer with strong Python skills and experience deploying AI models in production environments.",
  linkedin_profile: "https://www.linkedin.com/in/mehdi-laurent",
  github_profile: "https://github.com/mehdilaurent",
  search: ai_engineer_search
)

Candidate.create!(
  full_name: "Claire Moreau",
  summary: "Engineering leader with 12 years of experience. Has managed teams of 20+ engineers and led major platform refactoring projects.",
  linkedin_profile: "https://www.linkedin.com/in/claire-moreau",
  github_profile: "https://github.com/clairemoreau",
  search: cto_search
)

Candidate.create!(
  full_name: "Nicolas Petit",
  summary: "Former lead developer turned CTO. Strong technical background, excellent communication skills, and experience scaling engineering teams.",
  linkedin_profile: "https://www.linkedin.com/in/nicolas-petit",
  github_profile: "https://github.com/nicolaspetit",
  search: cto_search
)

puts "Done!"
puts "#{Search.count} searches created"
puts "#{Candidate.count} candidates created"


# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
