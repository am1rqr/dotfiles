{
  workspaces = ''
    #workspaces {
      background-color: @bg0;
      padding: 2px 6px;
      margin: 4px 3px;
      border-radius: 14px;
      border: 1px solid rgba(137, 180, 250, 0.12);
    }

    #workspaces button {
      padding: 0 6px;
      margin: 3px 2px;
      min-width: 18px;
      color: @fg1;
      background: transparent;
      border: none;
      border-radius: 10px;
      transition: all 200ms ease;
    }

    #workspaces button:hover {
      background: rgba(205, 214, 244, 0.12);
      color: @fg0;
      box-shadow: none;
      text-shadow: none;
    }

    #workspaces button.active {
      color: @bg1;
      background: @blue;
      padding: 0 10px;
      font-weight: 700;
    }

    #workspaces button.urgent {
      color: @bg1;
      background: @red;
    }
  '';
}
