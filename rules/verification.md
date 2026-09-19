# Verification (anti-hallucination)

- Every claim about behaviour, coverage, performance, or test results must come from a
  command you ran or a file you read in this session. Quote the actual output.
- Never cite an API, flag, function, or config key you have not seen in source or docs.
  If you can't check, say "unverified" next to it.
- "Tests pass" means you ran them and saw PASS. Not "should pass".
- Before writing a PR description, re-run the commands the description mentions
  (coverage, lint, benchmarks) and paste real numbers. Stale or assumed numbers are worse
  than no numbers: reviewers run them and lose trust.
- Quote error messages exactly. Don't paraphrase.
- Distinguish "I read this in the code" / "I inferred this" / "I'm guessing" in explanations.
- When a tool's documentation and its actual behaviour disagree, trust the behaviour you observed.
