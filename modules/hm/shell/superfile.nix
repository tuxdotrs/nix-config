{
  flake.modules.homeManager.shell = {
    programs.superfile = {
      enable = true;
      firstUseCheck = false;

      hotkeys = {
        # Global hotkeys
        confirm = ["enter" "right" "l"];
        quit = ["ctrl+c"];
        cd_quit = ["Q"];

        # Navigation
        list_up = ["k" "up"];
        list_down = ["j" "down"];
        page_up = ["pgup" ""];
        page_down = ["pgdown" ""];

        # File Panel Controls
        create_new_file_panel = ["n"];
        close_file_panel = ["q"];
        next_file_panel = ["tab"];
        previous_file_panel = ["shift+tab"];
        split_file_panel = ["N"];
        toggle_file_preview_panel = ["f"];
        open_sort_options_menu = ["o"];
        toggle_reverse_sort = ["R"];

        # Focus Manipulation
        focus_on_process_bar = ["ctrl+p"];
        focus_on_sidebar = ["ctrl+s"];
        focus_on_metadata = ["ctrl+d"];

        # File/Dir Creation/Renaming
        file_panel_item_create = ["a"];
        file_panel_item_rename = ["r"];

        # Main File Operations
        copy_items = ["y"];
        cut_items = ["x"];
        paste_items = ["p"];
        delete_items = ["d"];
        permanently_delete_items = ["D"];

        # Archive Manipulation
        extract_file = ["ctrl+e"];
        compress_file = ["ctrl+a"];

        # Editor Actions
        open_file_with_editor = ["e"];
        open_current_directory_with_editor = ["E"];

        # Other Actions
        pinned_directory = ["P"];
        toggle_dot_file = ["."];
        change_panel_mode = ["m"];
        open_help_menu = ["?"];
        open_spf_prompt = [">"];
        open_command_line = [":"];
        open_zoxide = ["z"];
        copy_path = ["Y"];
        copy_present_working_directory = ["c"];
        toggle_footer = ["ctrl+f"];

        # Typing hotkeys
        confirm_typing = ["enter"];
        cancel_typing = ["esc"];

        # Mode-Specific Hotkeys
        # Normal Mode
        parent_directory = ["-" "h" "left" "backspace"];
        search_bar = ["/"];

        # Selection Mode
        file_panel_select_mode_items_select_down = ["J"];
        file_panel_select_mode_items_select_up = ["K"];
        file_panel_select_all_items = ["A"];
      };

      settings = {
        theme = "poimandres";
        editor = "";
        dir_editor = "";
        auto_check_update = false;
        cd_on_quit = false;
        default_open_file_preview = true;
        show_image_preview = true;
        show_panel_footer_info = true;
        default_directory = "~";
        file_size_use_si = false;
        default_sort_type = 0;
        sort_order_reversed = false;
        case_sensitive_sort = false;
        shell_close_on_success = false;
        debug = false;
        ignore_missing_fields = false;
        nerdfont = true;
        transparent_background = true;
        file_preview_width = 0;
        code_previewer = "bat";
        sidebar_width = 20;
        border_top = "─";
        border_bottom = "─";
        border_left = "│";
        border_right = "│";
        border_top_left = "╭";
        border_top_right = "╮";
        border_bottom_left = "╰";
        border_bottom_right = "╯";
        border_middle_left = "├";
        border_middle_right = "┤";
        metadata = true;
        zoxide_support = true;
        enable_md5_checksum = false;
      };
    };
  };
}
