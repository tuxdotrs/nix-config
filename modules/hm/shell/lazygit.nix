{
  flake.modules.homeManager.shell = {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          showIcons = true;
          nerdFontsVersion = "3";
        };
        customCommands = [
          {
            key = "<c-a>";
            description = "AI-powered conventional commit";
            context = "global";
            command = "git commit -m \"{{.Form.CommitMsg}}\"";
            loadingText = "Generating commit messages...";
            prompts = [
              {
                type = "menu";
                key = "Type";
                title = "Type of change";
                options = [
                  {
                    name = "AI defined";
                    description = "Let AI analyze and determine the best commit type";
                    value = "ai-defined";
                  }
                  {
                    name = "build";
                    description = "Changes that affect the build system or external dependencies";
                    value = "build";
                  }
                  {
                    name = "feat";
                    description = "A new feature";
                    value = "feat";
                  }
                  {
                    name = "fix";
                    description = "A bug fix";
                    value = "fix";
                  }
                  {
                    name = "chore";
                    description = "Other changes that don't modify src or test files";
                    value = "chore";
                  }
                  {
                    name = "ci";
                    description = "Changes to CI configuration files and scripts";
                    value = "ci";
                  }
                  {
                    name = "docs";
                    description = "Documentation only changes";
                    value = "docs";
                  }
                  {
                    name = "perf";
                    description = "A code change that improves performance";
                    value = "perf";
                  }
                  {
                    name = "refactor";
                    description = "A code change that neither fixes a bug nor adds a feature";
                    value = "refactor";
                  }
                  {
                    name = "revert";
                    description = "Reverts a previous commit";
                    value = "revert";
                  }
                  {
                    name = "style";
                    description = "Changes that do not affect the meaning of the code";
                    value = "style";
                  }
                  {
                    name = "test";
                    description = "Adding missing tests or correcting existing tests";
                    value = "test";
                  }
                ];
              }
              {
                type = "menuFromCommand";
                title = "AI Generated Commit Messages";
                key = "CommitMsg";
                command = ''
                  bash -lc '
                  diff=$(git diff --cached)
                  if [ -z "$diff" ]; then
                    echo "No changes in staging. Add changes first."
                    exit 1
                  fi

                  SELECTED_TYPE="{{.Form.Type}}"
                  COMMITS_TO_SUGGEST=4

                  opencode run --format json --model=google/gemini-3.5-flash-lite --variant=none "
                  You are an expert at writing Git commits. Your job is to write commit messages that follow the Conventional Commits format.

                  The user has selected: $SELECTED_TYPE

                  Your task is to:
                  1. Analyze the code changes
                  2. Determine the most appropriate commit type if user selected ai-defined
                  3. Determine an appropriate scope, component, or area affected
                  4. Decide if this is a breaking change
                  5. Write clear, concise commit messages

                  Available commit types:
                  - feat: A new feature
                  - fix: A bug fix
                  - docs: Documentation only changes
                  - style: Changes that do not affect the meaning of the code
                  - refactor: A code change that neither fixes a bug nor adds a feature
                  - perf: A code change that improves performance
                  - test: Adding missing tests or correcting existing tests
                  - build: Changes that affect the build system or external dependencies
                  - ci: Changes to CI configuration files and scripts
                  - chore: Other changes that do not modify src or test files
                  - revert: Reverts a previous commit

                  Follow these guidelines:
                  - Structure: <type>(<scope>): <description>
                  - If user selected ai-defined, analyze the changes and pick the most suitable type
                  - If user selected a specific type, use that type: $SELECTED_TYPE
                  - Add scope in parentheses if applicable, for example auth, api, ui, config
                  - Use exclamation mark after type or scope for breaking changes: type(scope)!: description
                  - Use lowercase for description except proper nouns
                  - Use imperative mood: add, not added
                  - Keep description under 50 characters when possible
                  - No period at the end of subject line

                  IMPORTANT:
                  - Generate exactly $COMMITS_TO_SUGGEST different commit message options
                  - If user selected ai-defined, you can use different types for different options
                  - If user selected a specific type, all messages must use that type
                  - Only return commit messages, no explanations
                  - Do not use markdown code blocks
                  - One message per line

                  Previous commits for context:
                  $(git log --oneline -10)

                  Changes to analyze:
                  $(git diff --cached --stat)
                  $diff
                  " | JQ_TEXT=text jq -r "select(.type == env.JQ_TEXT) | .part.text? // empty"
                  '
                '';
              }
            ];
          }
        ];
      };
    };
  };
}
