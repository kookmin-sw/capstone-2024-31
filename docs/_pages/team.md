---
layout: page
title: team
include_in_header: false
order: 1
---

<h1>Team</h1>

<div class="teams">
  {% for info in site.team_info %} {% if info.name %}
  <div class="team">
      <a href="{{ info.github_url | relative_url }}">
        <div>
          <img src="{{ info.image | relative_url }}"  alt="{{ info.name }}">
        </div>
        <div>
          <h3>{{ info.name }}</h3>
          <p>{{ info.description }}</p>
        </div>
      </a>
    </div>
  {% endif %} {% endfor %}
</div>