set base_command "docker compose -f docker-compose.yml -f docker-compose.debug.yml"

function dc
  set command (echo -e "logs -f --tail 100\nup --force-recreate -d\nbuild\nbuild --no-cache\nup -d" | fzf --prompt="Command: ")

  if test -z "$command"
    commandline --function repaint
    return
  end

  set services (echo -e "all\n$(docker compose ps --services)" | fzf --prompt="Services: " --multi)

  if test -z "$services"
    commandline --function repaint
    return
  end

  if test "$services" = "all"
    set services ""
  end

  echo "Executing: $base_command $command $services"
  eval $base_command $command $services && dcl $services
end
