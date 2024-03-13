model = props["Model"].Value
local layout = {}
local title_size = {224, 32}
local btn_size = {32, 24}
local prop_size = {64,54}
local status_groupbox_size = {title_size[1], 5*btn_size[2]}
local VINX_groupbox_position = {0, title_size[2] + status_groupbox_size[2] + (0.5 * btn_size[2])}
local VINX_groupbox_size = {title_size[1], 5*btn_size[2]}

graphics = {
    {
      Type = "Header",
      Text = "Lightware VINX",
      HTextAlign = "Center",
      Color = Colors.lightware_red,
      FontSize = 16,
      Position = {0, 0},
      Size = title_size
    },
    {
      Type = "GroupBox",
      Text = "Status",
      HTextAlign = "Left",
      Fill = Colors.lightware_black,
      CornerRadius = 8,
      StrokeColor = Colors.lightware_red,
      Color = Colors.lightware_red,
      StrokeWidth = 1,
      Position = {0, title_size[2]},
      Size = status_groupbox_size
    },
    {
      Type = "Text",
      Text = "Online:",
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Bold",
      HTextAlign = "Right",
      Color = Colors.White,
      Position = {0, title_size[2] + (0.5 * btn_size[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    },
    {
      Type = "Text",
      Text = "IP Address:",
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Bold",
      HTextAlign = "Right",
      Color = Colors.White,
      Position = {0, title_size[2] + (1.5 * btn_size[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    },
    {
      Type = "Text",
      Text = "Model:",
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Bold",
      HTextAlign = "Right",
      Color = Colors.White,
      Position = {0, title_size[2] + (2.5 * btn_size[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    },
    {
      Type = "Text",
      Text = "Serial Number:",
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Bold",
      HTextAlign = "Right",
      Color = Colors.White,
      Position = {0, title_size[2] + (3.5 * btn_size[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    },
    {
      Type = "GroupBox",
      Text = "VINX",
      HTextAlign = "Left",
      Fill = Colors.lightware_black,
      CornerRadius = 8,
      StrokeColor = Colors.lightware_red,
      Color = Colors.lightware_red,
      StrokeWidth = 1,
      Position = VINX_groupbox_position,
      Size = VINX_groupbox_size
    },
    {
      Type = "Text",
      Text = "Video Channel Id:",
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Bold",
      HTextAlign = "Right",
      Color = Colors.White,
      Position = {VINX_groupbox_position[1], (VINX_groupbox_position[2] + (btn_size[2]))},
      Size = {3 * btn_size[1], btn_size[2]}
    }
}
if string.find(model, "ENC") then
    table.insert(
        graphics,
        {
          Type = "Text",
          Text = "Input 01 Sync:",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Bold",
          HTextAlign = "Right",
          Color = Colors.White,
          Position = {VINX_groupbox_position[1], (VINX_groupbox_position[2] +  (2 * btn_size[2]))},
          Size = {3 * btn_size[1], btn_size[2]}
        }
    )
end
if string.find(model, "210") then
    table.insert(
        graphics,
        {
          Type = "Text",
          Text = "Input 02 Sync:",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Bold",
          HTextAlign = "Right",
          Color = Colors.White,
          Position = {VINX_groupbox_position[1], (VINX_groupbox_position[2] +  (3 * btn_size[2]))},
          Size = {3 * btn_size[1], btn_size[2]}
        }
    )
end
-- System
layout["online"] = {
    PrettyName = "System~Online",
    Style = "Indicator",
    Color = {0, 255, 0},
    Position = {3 * btn_size[1], title_size[2] + (0.5 * btn_size[2])},
    Size = {btn_size[2], btn_size[2]}
}
layout["ip_address"] = {
    PrettyName = "System~IP Address",
    Style = "Text",
    Position = {3 * btn_size[1], title_size[2] + (1.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
layout["model"] = {
    PrettyName = "System~Model Name",
    Style = "Text",
    Position = {3 * btn_size[1], title_size[2] + (2.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
layout["serial_number"] = {
    PrettyName = "System~Serial Number",
    Style = "Text",
    Position = {3 * btn_size[1], title_size[2] + (3.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
layout["video_channel_id"] = {
    PrettyName = "Video Channel Id",
    Style = "Text",
    Position = {3 * btn_size[1], title_size[2] + (6.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
if string.find(model, "ENC") then
    layout["input_01_sync"] = {
        PrettyName = "Input 01~Sync",
        Style = "Indicator",
        Color = {0, 255, 0},
        Position = {3 * btn_size[1], title_size[2] + (7.5 * btn_size[2])},
        Size = {btn_size[2], btn_size[2]}
    }
end
if string.find(model, "210") then
    layout["input_02_sync"] = {
        PrettyName = "Input 02~Sync",
        Style = "Indicator",
        Color = {0, 255, 0},
        Position = {3 * btn_size[1], title_size[2] + (8.5 * btn_size[2])},
        Size = {btn_size[2], btn_size[2]}
    }
end