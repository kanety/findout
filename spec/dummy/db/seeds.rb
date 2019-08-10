time = Time.parse('2019-01-01 10:00')
50.times do |i|
  group = Group.create(
    name: "group_#{i+1}",
    title: "GROUP_#{i+1}",
    created_at: time + i.days,
    updated_at: time + i.days
  )
  User.create(
    name: "user_#{i+1}",
    title: "USER_#{i+1}",
    age: (i / 10) * 10,
    created_at: time + i.days,
    updated_at: time + i.days,
    group: group
  )
end
