-- Manually maintained database patches

-- Add missing quests
local D = CodexDB.quests.data
D[7668]={
  class=64,
  ['end']={
    U={13417},
  },
  lvl=60,
  min=58,
  obj={
    I={18880,18746},
  },
  race=178,
  start={
    U={13417},
  },
}
D[7669]={
  class=64,
  ['end']={
    U={13417},
  },
  lvl=60,
  min=58,
  race=178,
  start={
    U={13417},
  },
}
D[7670]={
  class=2,
  ['end']={
    U={928},
  },
  excl={7638},
  lvl=60,
  min=60,
  next=7637,
  race=77,
  start={
    U={5149},
  },
}

if select(4, GetAddOnInfo('MergeQuestieToCodexDB')) then return end
local D = CodexDB.units.data

if UnitFactionGroup('player') == 'Alliance' then
  D[13778].coords={
    {48.5,58.3,2597,0}, --add
    {50.2,65.3,2597,0}, --add
    {49.3,84.4,2597,0}, --add
    {48.3,84.3,2597,0}, --add
  }
end

-- Chief Murgut <https://classic.wowhead.com/npc=12918/chief-murgut>
D[12918].coords={
  {56.4,63.6,331,0},
}

-- Magrami Spectre <https://classic.wowhead.com/npc=11560/magrami-spectre>
D[11560].coords={
  {62.4,91.4,405,300},
  {63.2,92.2,405,300},
  {63.4,91.4,405,300},
  {63.4,92.6,405,300},
  {63.6,92.4,405,300},
  {63.8,92.6,405,300},
  {64.2,91.4,405,300},
  {64.4,90.4,405,300},
  {64.6,91.6,405,300},
  {64.6,92.6,405,300},
  {64.8,90.4,405,300},
  {64.8,91.0,405,300},
  {65.0,89.4,405,300},
  {65.6,90.2,405,300},
  {65.6,90.6,405,300},
}
